local M = {}

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    require "notify" "Missing null-ls dependency"
    return
  end

  local default_opts = require("lsp").get_common_opts()

  local sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.formatting.stylua,
  }

  null_ls.setup(vim.tbl_deep_extend("force", default_opts, { sources = sources }))
end

return M
