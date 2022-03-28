local M = {}

local Log = require "core.log"

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end

  local default_opts = require("config.lsp").get_common_opts()

  null_ls.setup(vim.tbl_deep_extend("force", default_opts, {
    sources = 
    null_ls.builtins.formatting.prettierd.with {
      filetypes = { "html", "javascript", "json", "typescript", "yaml", "markdown" },
    },
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.flake8,
  }))
end

return M
