-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

local lsp_config = require "config.lsp.config"
function M.setup()
  local config = { -- your config
    virtual_text = lsp_config.diagnostics.virtual_text,
    signs = lsp_config.diagnostics.signs,
    underline = lsp_config.diagnostics.underline,
    update_in_insert = lsp_config.diagnostics.update_in_insert,
    severity_sort = lsp_config.diagnostics.severity_sort,
    float = lsp_config.diagnostics.float,
  }
  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = false,
    signs = true,
    update_in_insert = false,
  })

  local on_references = vim.lsp.handlers["textDocument/references"]
  vim.lsp.handlers["textDocument/references"] = vim.lsp.with(on_references, { loclist = true, virtual_text = true })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

function M.show_line_diagnostics()
  local config = lsp_config.diagnostics.float
  config.scope = "line"
  return vim.diagnostic.open_float(0, config)
end

return M