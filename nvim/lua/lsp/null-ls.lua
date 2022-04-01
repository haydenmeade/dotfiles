local M = {}

local Log = require "core.log"

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end

  local default_opts = require("lsp").get_common_opts()

  null_ls.setup(vim.tbl_deep_extend("force", default_opts, {
    sources = {
      -- https://github.com/ThePrimeagen/refactoring.nvim
      -- refactoring ({ "go", "javascript", "lua", "python", "typescript" })
      -- null_ls.builtins.code_actions.refactoring,

      -- https://github.com/fsouza/prettierd
      -- formatting js/ts/html/css/json
      null_ls.builtins.formatting.prettierd,
      -- https://github.com/mantoni/eslint_d.js
      -- code actions for js/ts
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.code_actions.eslint_d,

      -- https://github.com/JohnnyMorganz/StyLua
      -- lua formatter
      null_ls.builtins.formatting.stylua,

      -- GO lint:https://golangci-lint.run/
      -- null_ls.builtins.diagnostics.golangci_lint,
      -- alt:https://revive.run/
      null_ls.builtins.diagnostics.revive,
      -- GO formatter:https://github.com/mvdan/gofumpt
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,

      -- Ruby formatter https://github.com/ruby-formatter/rufo
      -- null_ls.builtins.formatting.rufo,

      -- sh
      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.formatting.shfmt,

      -- maybe:
      -- python diagnostics
      -- null_ls.builtins.diagnostics.flake8,
      -- python formatter
      -- null_ls.builtins.formatting.black
    },
  }))
end

return M
