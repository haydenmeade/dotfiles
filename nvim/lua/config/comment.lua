local M = {}

function M.setup()
  require("Comment").setup {
    mappings = { extra = false },
  }
end

return M
