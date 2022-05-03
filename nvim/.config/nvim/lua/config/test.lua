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
  local ok, ultest = h.safe_require "ultest"
  if not ok then
    return
  end

  vim.g.ultest_use_pty = 1
  -- vim.g.ultest_virtual_text = 1
  vim.api.nvim_exec(
    [[
        let test#strategy = "neovim"
    ]],
    false
  )

  local builders = {
    -- Go Test Debugging
    ["go#richgo"] = function(cmd)
      local args = {}

      for i = 3, #cmd, 1 do
        local arg = cmd[i]
        if vim.startswith(arg, "-") then
          arg = "-test." .. string.sub(arg, 2)
        end
        args[#args + 1] = arg
      end
      print(vim.inspect(args))
      return {
        dap = {
          type = "go",
          request = "launch",
          mode = "test",
          program = "${workspaceFolder}",
          dlvToolPath = vim.fn.exepath "dlv",
          args = args,
        },
        parse_result = function(lines)
          return lines[#lines] == "FAIL" and 1 or 0
        end,
      }
    end,
  }
  ultest.setup { builders = builders }
end

return M
