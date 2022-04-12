local M = {}

function M.config()
  return {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  }
end

return M
