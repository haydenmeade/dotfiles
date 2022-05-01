local M = {}

function M.setup()
  local ok, octo = h.safe_require "octo"
  if not ok then
    return
  end
end

return M
