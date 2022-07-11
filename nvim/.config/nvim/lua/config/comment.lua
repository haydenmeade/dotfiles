local M = {}

function M.setup()
  local ok, comment = h.safe_require("Comment")
  if not ok then
    return
  end
  comment.setup({
    mappings = {
      -- gco
      -- gcO
      -- gcA
      extra = true,
      -- gcc
      -- gcb
      -- gc[count][motion]
      -- gb[count][motion]
      basic = true,
    },
  })
end

return M
