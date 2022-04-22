local M = {}

local Log = require "core.log"

function M.setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    Log:error "Missing null-ls dependency"
    return
  end
  local function exist(bin)
    return vim.fn.exepath(bin) ~= ""
  end

  local default_opts = require("lsp").get_common_opts()

  local sources = {
    -- https://github.com/ThePrimeagen/refactoring.nvim
    -- refactoring ({ "go", "javascript", "lua", "python", "typescript" })
    -- null_ls.builtins.code_actions.refactoring,

    -- maybe:
    -- python diagnostics
    -- null_ls.builtins.diagnostics.flake8,
    -- python formatter
    -- null_ls.builtins.formatting.black
  }
  if exist "prettierd" then
    -- https://github.com/fsouza/prettierd
    -- formatting js/ts/html/css/json
    table.insert(sources, null_ls.builtins.formatting.prettierd)
  end
  if exist "rubocop" then
    -- Ruby formatter
    table.insert(sources, null_ls.builtins.formatting.rubocop)
  end

  -- shell script
  if exist "shellcheck" then
    table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
  end

  -- shell script
  if exist "shfmt" then
    table.insert(sources, null_ls.builtins.formatting.shfmt)
  end

  -- golang
  if exist "golines" then
    -- table.insert(sources, null_ls.builtins.formatting.gofumpt)

    -- golines too slow
    -- table.insert(
    --   sources,
    --   null_ls.builtins.formatting.golines.with {
    --     extra_args = {
    --       "--max-len=120",
    --       "--base-formatter=gofumpt",
    --     },
    --   }
    -- )
    -- elseif exist "gofmt" then
    --   table.insert(sources, null_ls.builtins.formatting.gofmt)
  end
  if exist "goimports" then
    table.insert(sources, null_ls.builtins.formatting.goimports)
  end

  if exist "revive" then
    -- GO lint:https://golangci-lint.run/
    -- https://revive.run/
    table.insert(sources, null_ls.builtins.diagnostics.revive)
  elseif exist "golangci-lint" then
    table.insert(sources, null_ls.builtins.diagnostics.golangci_lint)
  end

  -- docker
  if exist "hadolint" then
    table.insert(sources, null_ls.builtins.diagnostics.hadolint)
  end

  -- if exist "eslint_d" then
  --   -- https://github.com/mantoni/eslint_d.js
  --   -- code actions for js/ts
  --   table.insert(sources, null_ls.builtins.diagnostics.eslint_d)
  --   table.insert(sources, null_ls.builtins.code_actions.eslint_d)
  -- end
  -- js, ts
  -- lua
  if exist "selene" then
    table.insert(sources, null_ls.builtins.diagnostics.selene)
  end
  if exist "markdownlint" then
    table.insert(sources, null_ls.builtins.diagnostics.markdownlint)
  end

  if exist "stylua" then
    -- https://github.com/JohnnyMorganz/StyLua
    table.insert(sources, null_ls.builtins.formatting.stylua)
  end

  null_ls.setup(vim.tbl_deep_extend("force", default_opts, { sources = sources }))
end

return M
