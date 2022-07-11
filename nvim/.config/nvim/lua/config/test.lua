local M = {}

function M.coverage()
  local ok, coverage = h.safe_require "coverage"
  if not ok then
    return
  end

  local colors = {
    green = "#98be65",
    red = "#ec5f67",
  }

  coverage.setup {
    commands = true,
    lang = {
      typescript = {
        coverage_file = "coverage/lcov.info",
      },
      javascript = {
        coverage_file = "coverage/lcov.info",
      },
      go = {
        coverage_file = "coverage.lcov",
      },
    },
    highlights = {
      covered = { fg = colors.green },
      uncovered = { fg = colors.red },
    },
  }
end

function M.setup()
  -- local ok, ultest = h.safe_require "ultest"
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

  require("neotest").setup {
    adapters = {
      require "neotest-jest" {
        -- jestConfigFile = function(p)
        --   return ""
        -- end,
      },
      require "neotest-go",
      require "neotest-plenary",
      -- require "neotest-vim-test" {},
    },
  }
end

return M
