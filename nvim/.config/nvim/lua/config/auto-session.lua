local M = {}

function M.setup()
  local ok, session = h.safe_require "auto-session"
  if not ok then
    return
  end
  session.setup {
    log_level = "error",
    pre_save_cmds = { "NvimTreeClose" },
  }
end

return M
