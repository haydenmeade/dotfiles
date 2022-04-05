vim.g.ultest_use_pty = 1

local M = {}

function M.coverage()
  local ok, coverage = h.safe_require "coverage"
  if not ok then
    return
  end

  local colors = require("onedarkpro").get_colors(vim.g.onedarkpro_style)

  coverage.setup {
    commands = false,
    highlights = {
      covered = { fg = colors.green },
      uncovered = { fg = colors.red },
    },
  }
end

function M.setup()
  vim.api.nvim_exec(
    [[
        let test#strategy = "dispatch"
        let test#neovim#term_position = "belowright"
        let g:test#preserve_screen = 1
    ]],
    false
  )

  local builders = {
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
  require("ultest").setup { builders = builders }
end

return M
