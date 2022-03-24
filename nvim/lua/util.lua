_G.Util = {}
-- Reload all user config lua modules
Util.Reload = function()
	local lua_dirs = vim.fn.glob("./lua/*", 0, 1)
	for _, dir in ipairs(lua_dirs) do
		dir = string.gsub(dir, "./lua/", "")
		require("plenary.reload").reload_module(dir)
	end
end
local get_mapper = function(mode, noremap)
	return function(lhs, rhs, opts)
		opts = opts or {}
		opts.noremap = noremap
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

Util.noremap = get_mapper("n", false)
Util.nnoremap = get_mapper("n", true)
Util.inoremap = get_mapper("i", true)
Util.tnoremap = get_mapper("t", true)
Util.vnoremap = get_mapper("v", true)

return Util
