local M = {}
local Log = require("core.log")
local config = require("lsp.config")

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
  end
  return capabilities
end

function M.get_common_opts()
  return {
    capabilities = M.common_capabilities(),
    flags = { debounce_text_changes = 100 },
  }
end

---Resolve the configuration for a server based on both common and user configuration
---@param name string
---@return table
local function resolve_config(name)
  local opts = M.get_common_opts()
  local has_custom_provider, custom_config = pcall(require, join_paths("lsp", name))
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. name)
    opts = vim.tbl_deep_extend("force", opts, custom_config.config())
  end

  return opts
end

function M.setup()
  local ok, lspconfig = h.safe_require("lspconfig")
  if not ok then
    return
  end

  for _, sign in ipairs(config.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      require("lsp_signature").on_attach({}, bufnr)
      require("config.lsp_keymap").register_lsp(bufnr)
    end,
  })

  require("mason").setup()
  local mason = require("mason-lspconfig")
  mason.setup({
    ensure_installed = {
      "lua_ls",
    },
    automatic_installation = true,
    log_level = vim.log.levels.INFO,
  })

  -- lspconfig.eslint.setup(resolve_config("eslint"))
  -- lspconfig.ts_ls.setup(resolve_config("ts_ls"))
  lspconfig.gopls.setup(resolve_config("gopls"))
  -- lspconfig.golangci_lint_ls.setup(resolve_config("golangci_lint_ls"))
  lspconfig.jsonls.setup(resolve_config("jsonls"))
  lspconfig.lua_ls.setup(resolve_config("lua_ls"))
  lspconfig.yamlls.setup(resolve_config("yamlls"))
  lspconfig.bashls.setup(resolve_config("bashls"))
  lspconfig.bufls.setup(resolve_config("bufls"))
  -- lspconfig.sqlls.setup(resolve_config("sqlls"))
  --  lspconfig.pyright.setup(resolve_config("pyright"))
  -- lspconfig.rust_analyzer.setup(resolve_config("rust_analyzer"))
  -- lspconfig.terraformls.setup(resolve_config("terraformls"))
end

return M
