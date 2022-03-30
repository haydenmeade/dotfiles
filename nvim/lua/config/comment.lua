local M = {}

function M.setup()
  require("Comment").setup {
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
  }
end

return M
