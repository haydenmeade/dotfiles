local M = {}

function M.setup()
  local ok, fzf = h.safe_require("fzf-lua")
  if not ok then
    return
  end
  fzf.setup({})
end

return M
