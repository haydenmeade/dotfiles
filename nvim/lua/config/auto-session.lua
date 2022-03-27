local M = {}

function M.setup()
  require("auto-session").setup {
    log_level = "error",
  }
end

return M
