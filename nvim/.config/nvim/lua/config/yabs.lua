local M = {}

function M.setup()
  local ok, yabs = h.safe_require("yabs")
  if not ok then
    return
  end

  yabs:setup({
    languages = {
      go = {
        default_task = "run",
        tasks = { run = { command = "go run %", output = "quickfix" } },
      },
      ruby = {
        default_task = "run",
        tasks = { run = { command = "ruby %", output = "quickfix" } },
      },
      lua = {
        default_task = "run",
        tasks = { run = { command = "make", output = "terminal" } },
      },
    },
  })
end

return M
