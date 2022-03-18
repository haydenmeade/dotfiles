local M = {}

local opts = {
	log_level = "error",
}

function M.setup()
	require("auto-session").setup(opts)
end

return M
