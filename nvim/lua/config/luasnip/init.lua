local M = {}

function M.setup()
	local ls = require("luasnip")
	local types = require("luasnip.util.types")

	ls.snippets = {
		all = require("config.luasnip.ft.all"),
		go = require("config.luasnip.ft.go"),
		lua = require("config.luasnip.ft.lua"),
	}
	require("luasnip.loaders.from_vscode").lazy_load()

	ls.config.set_config({
		-- This tells LuaSnip to remember to keep around the last snippet.
		-- You can jump back into it even if you move outside of the selection
		history = true,

		updateevents = "TextChanged,TextChangedI",

		enable_autosnippets = true,

		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { " ", "TSTextReference" } },
				},
			},
			[types.insertNode] = {
				active = {
					virt_text = { { "●", "GruvboxBlue" } },
				},
			},
		},
	})

	vim.keymap.set({ "i", "s" }, "<C-l>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end)

	vim.keymap.set({ "i", "s" }, "<C-h>", function()
		if ls.choice_active() then
			ls.change_choice(-1)
		end
	end)
end

return M
