local M = {}

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    vim.notify("Missing null-ls dependency")
    return
  end

  local default_opts = require("lsp").get_common_opts()

  local sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.sqlfluff.with({
      extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),
    null_ls.builtins.diagnostics.sqlfluff.with({
      extra_args = { "--dialect", "postgres" }, -- change to your dialect
    }),
  }
  local function exist(bin)
    return vim.fn.exepath(bin) ~= ""
  end

  for _, source in ipairs(sources) do
    if not exist(source.name) then
      vim.notify("unable to find shell tool - " .. source.name)
    end
  end

  null_ls.setup(vim.tbl_deep_extend("force", default_opts, { sources = sources }))
end

return M
