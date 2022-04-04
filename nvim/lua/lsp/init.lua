local M = {}
local Log = require "core.log"
local config = require "lsp.config"

-- TODO autoinstall?
local lsp_providers = {
  "pyright",
  "gopls",
  "sumneko_lua",
  "tsserver",
  "solargraph",
  "clangd",
  "jsonls",
  "bashls",
  "yamlls",
}

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  -- Code actions
  capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = (function()
          local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
          table.sort(res)
          return res
        end)(),
      },
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  return capabilities
end

local function select_default_formater(client)
  if client.name == "null-ls" then
    return
  end
  local s = require "null-ls.sources"
  local client_filetypes = client.config.filetypes or {}
  local done = false
  for _, filetype in ipairs(client_filetypes) do
    local supported_formatters = s.get_supported(filetype, "formatting")
    if not vim.tbl_isempty(supported_formatters) then
      done = true
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end
  end
  if done then
    Log:debug("Formatter overriding for " .. client.name)
  end
end

function M.common_on_exit(_, _) end

function M.common_on_init(client, _)
  select_default_formater(client)
end

function M.common_on_attach(client, bufnr)
  require("lsp_signature").on_attach {
    bind = true,
    handler_opts = { border = "single" },
  }

  require("config.whichkey").register_lsp(bufnr)

  if client.resolved_capabilities.document_formatting then
    require("core.autocmds").configure_format_on_save()
  end
  require("core.autocmds").enable_lsp_document_highlight(bufnr)
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
---@param user_config table [optional]
---@return table
local function resolve_config(name, user_config)
  local opts = M.get_common_opts()
  local has_custom_provider, custom_config = pcall(require, join_paths("lsp", name))
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. name)
    opts = vim.tbl_deep_extend("force", opts, custom_config.config())
  end

  if user_config then
    opts = vim.tbl_deep_extend("force", opts, user_config)
  end

  return opts
end

function M.setup()
  Log:debug "Setting up LSP support"

  local lsp_status_ok, _ = pcall(require, "lspconfig")
  if not lsp_status_ok then
    Log:debug "No lspconfig"
    return
  end

  for _, sign in ipairs(config.diagnostics.signs.values) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- vim handlers
  require("lsp.handlers").setup()

  require("lsp.null-ls").setup()

  require("core.autocmds").configure_format_on_save()

  require("nvim-lsp-installer").on_server_ready(function(server)
    server:setup(resolve_config(server.name))
  end)
end

return M
