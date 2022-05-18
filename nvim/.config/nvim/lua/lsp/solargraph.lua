local M = {}

function M.config()
  return {
    settings = {
      solargraph = {
        diagnostics = true,
        completion = true,
        formatting = false,
      },
    },
  }
end

return M
