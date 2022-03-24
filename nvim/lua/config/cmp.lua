local M = {}

function M.setup()
	local cmp = require("cmp")
	local ls = require("luasnip")
	local compare = require("cmp.config.compare")

	local function has_words_before()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local press = function(key)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
	end

	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	cmp.setup({
		formatting = {
			format = require("lspkind").cmp_format({
				with_text = true,
				menu = {
					nvim_lsp = "[LSP]",
					buffer = "[Buffer]",
					nvim_lua = "[Lua]",
					luasnip = "[Snippet]",
					treesitter = "[treesitter]",
					look = "[Look]",
					path = "[Path]",
					emoji = "[Emoji]",
				},
			}),
		},
		documentation = {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
		sorting = {
			comparators = {
				function(...)
					return require("cmp_buffer"):compare_locality(...)
				end,
				compare.offset,
				compare.exact,
				compare.score,
				compare.recently_used,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
			},
		},
		mapping = {
			["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-e>"] = cmp.mapping.close(),
			["<C-y>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if ls.expand_or_locally_jumpable() then
					ls.expand_or_jump()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, {
				"i",
				"s",
				"c",
			}),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if ls.jumpable(-1) then
					ls.jump(-1)
				elseif cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, {
				"i",
				"s",
				"c",
			}),
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp", max_item_count = 10 },
			{ name = "nvim_lua", max_item_count = 5 },
			{ name = "luasnip", priority = 10 },
			{ name = "treesitter", max_item_count = 10 },
			{ name = "buffer", keyword_length = 5, max_item_count = 5 },
			{ name = "path" },
		},
		completion = { completeopt = "menu,menuone,noinsert", keyword_length = 1 },
		experimental = {
			ghost_text = true,
		},
	})

	-- If you want insert `(` after select function or method item
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
	cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"

	-- Use cmdline & path source for ':'.
	cmp.setup.cmdline(":", {
		sources = cmp.config.sources({
			{ name = "path", max_item_count = 5 },
		}, {
			{ name = "cmdline", max_item_count = 15 },
		}),
	})

	-- lsp_document_symbols
	cmp.setup.cmdline("/", {
		sources = cmp.config.sources({
			{ name = "nvim_lsp_document_symbol", max_item_count = 8, keyword_length = 3 },
		}, {
			{ name = "buffer", max_item_count = 5, keyword_length = 5 },
		}),
	})
end

return M
