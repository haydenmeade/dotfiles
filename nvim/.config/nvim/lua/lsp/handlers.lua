local M = {}

local lsp_config = require "lsp.config"
function M.setup()
  vim.diagnostic.config {
    virtual_text = lsp_config.diagnostics.virtual_text,
    signs = lsp_config.diagnostics.signs,
    underline = lsp_config.diagnostics.underline,
    update_in_insert = lsp_config.diagnostics.update_in_insert,
    severity_sort = lsp_config.diagnostics.severity_sort,
    float = lsp_config.diagnostics.float,
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    require "notify" ({ result.message }, lvl, {
      title = "LSP | " .. client.name,
      timeout = 10000,
      keep = function()
        return lvl == "ERROR" or lvl == "WARN"
      end,
    })
  end
end

return M
