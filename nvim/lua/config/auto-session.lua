local M = {}

local opts = {}

function M.setup()
	require("auto-session").setup(opts)
end

return M
