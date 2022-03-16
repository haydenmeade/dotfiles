local M = {}

function M.setup()
  require("Comment").setup {
    mappings = { extra = true },
  }
end

return M
