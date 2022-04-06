local M = {}

function M.setup()
  local ok, neogit = h.safe_require "neogit"
  if not ok then
    return
  end
  neogit.setup { integrations = { diffview = true } }
end

return M
