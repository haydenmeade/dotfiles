local M = {}

function M.coverage()
  local ok, coverage = h.safe_require("coverage")
  if not ok then
    return
  end

  local colors = {
    green = "#98be65",
    red = "#ec5f67",
  }

  coverage.setup({
    commands = true,
    lang = {
      go = {
        coverage_file = "tmp/coverage.out",
      },
    },
    highlights = {
      covered = { fg = colors.green },
      uncovered = { fg = colors.red },
    },
  })
end

function M.setup()
  -- local ok, neotest = h.safe_require("neotest")
  -- if not ok then
  --   return
  -- end

  -- vim.g.ultest_use_pty = 1
  vim.g.preserve_screen = 1
  -- vim.g.ultest_virtual_text = 1
  vim.api.nvim_exec(
    [[
        let test#strategy = "kitty"
    ]],
    false
  )

  -- neotest.setup({
  --   adapters = {
  --     require("neotest-go"),
  --     require("neotest-plenary"),
  --     -- require "neotest-vim-test" {},
  --   },
  -- })
end

return M
