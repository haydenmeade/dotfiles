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

function M.common_on_exit(_, _) end

function M.common_on_init(_, _) end

function M.common_on_attach(_, bufnr)
  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = { border = "single" },
  })

  require("config.lsp_keymap").register_lsp(bufnr)
end

function M.get_common_opts()
  return {
    on_attach = M.common_on_attach,
    on_init = M.common_on_init,
    on_exit = M.common_on_exit,
    capabilities = M.common_capabilities(),
    flags = { debounce_text_changes = 150 },
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

  -- custom handlers
  require("lsp.handlers").setup()

  require("lsp.null-ls").setup()

  require("core.autocmds").configure_format_on_save()

  require("mason").setup()
  local mason = require("mason-lspconfig")
  mason.setup({
    ensure_installed = {
      "lua_ls",
    },
    automatic_installation = true,
    log_level = vim.log.levels.INFO,
  })

  require("lsp.tsserver").config()
  lspconfig.eslint.setup(resolve_config("eslint"))
  lspconfig.gopls.setup(resolve_config("gopls"))
  lspconfig.golangci_lint_ls.setup(resolve_config("golangci_lint_ls"))
  lspconfig.jsonls.setup(resolve_config("jsonls"))
  lspconfig.lua_ls.setup(resolve_config("lua_ls"))
  lspconfig.yamlls.setup(resolve_config("yamlls"))
  lspconfig.bashls.setup(resolve_config("bashls"))
  lspconfig.cssls.setup(resolve_config("cssls"))
end

return M
