local M = {}

local opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
}

local vopts = {
	mode = "v",
	prefix = "<leader>",
	buffer = nil,
	silent = false,
	noremap = true,
	nowait = true,
}

local xopts = {
	mode = "x",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
}

local mappings = {
	["w"] = { "<Cmd>w!<Cr>", "Save" },
	["q"] = { "<Cmd>q!<Cr>", "Quit" },

	-- System
	["z"] = {
		name = "System",
		b = {
			"<Cmd>hi Normal ctermbg=none guibg=none<CR>",
			"Transparent background",
		},
		s = { ":<C-u>SaveSession<Cr>", "Save session" },
		l = { ":<C-u>SearchSession<Cr>", "Load session" },
		h = { "<Cmd>ToggleTerm<CR>", "New horizontal terminal" },
		t = { "<Cmd>terminal<CR>", "New terminal" },
		z = {
			"<Cmd>lua require('config.telescope').search_dotfiles()<CR>",
			"Configuration",
		},
		r = { "<Cmd>lua require('util').Reload()<CR>", "Reload config" },
		m = { "<Cmd>messages<Cr>", "Messages" },
		p = { "<Cmd>messages clear<Cr>", "Clear messages" },
		f = { "<Cmd>FloatermNew<Cr>", "Floating terminal" },
		i = { "<Cmd>PackerUpdate<Cr>", "Packer update" },
		y = { "<Cmd>PackerSync<Cr>", "Packer update" },
	},

	-- Buffer
	b = {
		name = "Buffer",
		a = { "<Cmd>BWipeout other<Cr>", "Delete all buffers" },
		d = { "<Cmd>bd<Cr>", "Delete current buffer" },
		l = { "<Cmd>ls<Cr>", "List buffers" },
		n = { "<Cmd>bn<Cr>", "Next buffer" },
		p = { "<Cmd>bp<Cr>", "Previous buffer" },
		f = { "<Cmd>bd!<Cr>", "Force delete current buffer" },
	},

	-- Quick fix
	c = {
		name = "Quickfix",
		o = { "<Cmd>copen<Cr>", "Open quickfix" },
		c = { "<Cmd>cclose<Cr>", "Close quickfix" },
		n = { "<Cmd>cnext<Cr>", "Next quickfix" },
		p = { "<Cmd>cprev<Cr>", "Previous quickfix" },
		x = { "<Cmd>cex []<Cr>", "Clear quickfix" },
		t = { "<Cmd>BqfAutoToggle<Cr>", "Toggle preview" },
	},

	-- File
	f = {
		name = "File",
		b = { "<Cmd>Telescope buffers<Cr>", "Search buffers" },
		c = { "<Cmd>Telescope current_buffer_fuzzy_find<Cr>", "Search current buffer" },
		f = { "<Cmd>Telescope git_files<Cr>", "Git files" },
		y = { "<Cmd>Telescope find_files<Cr>", "Find files" },
		g = { "<Cmd>Telescope live_grep<Cr>", "Live grep" },
		h = { "<Cmd>Telescope help_tags<Cr>", "Help" },
		p = { "<Cmd>Telescope file_browser<Cr>", "Pop-up file browser" },
		o = { "<Cmd>Telescope oldfiles<Cr>", "Old files" },
		m = { "<Cmd>Telescope marks<Cr>", "Mark" },
		n = { "<Cmd>ene <BAR> startinsert <Cr>", "New file" },
		s = { "<Cmd>Telescope symbols<Cr>", "Symbols" },
		a = { "<Cmd>xa<Cr>", "Save all & quit" },
		e = { "<Cmd>NvimTreeToggle<CR>", "Explorer" },
		t = { "<Cmd>Telescope<CR>", "Telescope" },
		l = { "<Cmd>e!<CR>", "Reload file" },
	},

	-- Git
	g = {
		name = "Source code",
		a = { "<Cmd>Telescope repo list<Cr>", "All repositories" },
		s = { "<Cmd>Git<Cr>", "Git status" },
		p = { "<Cmd>Git push<Cr>", "Git push" },
		b = { "<Cmd>Git branch<Cr>", "Git branch" },
		d = { "<Cmd>Gvdiffsplit<Cr>", "Git diff" },
		f = { "<Cmd>Git fetch --all<Cr>", "Git fetch" },
		m = { "<Cmd>GitMessenger<Cr>", "Git messenger" },
		n = { "<Cmd>Neogit<Cr>", "NeoGit" },
		v = { "<Cmd>DiffviewOpen<Cr>", "Diffview open" },
		c = { "<Cmd>DiffviewClose<Cr>", "Diffview close" },
		h = { "<Cmd>DiffviewFileHistory<Cr>", "File history" },
		["r"] = {
			name = "Rebase",
			u = {
				"<Cmd>Git rebase upstream/master<Cr>",
				"Git rebase upstream/master",
			},
			o = {
				"<Cmd>Git rebase origin/master<Cr>",
				"Git rebase origin/master",
			},
		},
		x = {
			name = "Diff",
			["2"] = { "<Cmd>diffget //2", "Diffget 2" },
			["3"] = { "<Cmd>diffget //3", "Diffget 3" },
		},
		g = {
			"<Cmd>DogeGenerate<Cr>",
			"Generate doc",
		},
		y = { name = "Git URL" },
	},

	-- Project
	p = {
		name = "Project",
		s = {
			"<Cmd>lua require('config.telescope').switch_projects()<CR>",
			"Search files",
		},
		p = {
			"<Cmd>lua require('telescope').extensions.project.project({})<Cr>",
			"List projects",
		},
		r = {
			"<Cmd>Telescope projects<Cr>",
			"Recent projects",
		},
	},

	-- Search
	["s"] = {
		name = "Search",
		w = {
			"<Cmd>lua require('telescope').extensions.arecibo.websearch()<CR>",
			"Web search",
		},
		s = { "<Cmd>lua require('spectre').open()<CR>", "Search file" },
		z = { "<Plug>SearchNormal", "Browser search" },
		v = {
			"<Cmd>lua require('spectre').open_visual({select_word=true})<CR>",
			"Visual search",
		},
		f = {
			"viw:lua require('spectre').open_file_search()<Cr>",
			"Open file search",
		},
		c = { "q:", "Command history" },
		g = { "q/", "Grep history" },
		o = { "<Cmd>SymbolsOutline<CR>", "Symbols Outline" },
		b = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find buffer" },
		l = { "<Cmd>Telescope luasnip<CR>", "Search snippets" },
	},

	-- Testing
	t = {
		name = "Test",
		n = { "<Cmd>w<CR>:UltestNearest<CR>", "Test nearest" },
		f = { "<Cmd>w<CR>:Ultest<CR>", "Test file" },
		o = { "<Cmd>w<CR>:UltestOutput<CR>", "Test output" },
		l = { "<Cmd>w<CR>:UltestLast<CR>", "Test last" },
		v = { "<Cmd>w<CR>:TestVisit<CR>", "Test visit" },
		d = { "<Cmd>w<CR>:UltestDebug<CR>", "Test debug" },
		g = { "<Cmd>w<CR>:UltestDebugNearest<CR>", "Test debug nearest" },
		t = { "<Cmd>w<CR>:UltestSummary<CR>", "Test summary" },
		c = { "<Cmd>w<CR>:UltestClear<CR>", "Test clear" },
		s = { "<Cmd>w<CR>:UltestStop<CR>", "Test stop" },
	},

	-- Run
	r = {
		name = "Run",
		x = "Swap next parameter",
		X = "Swap previous parameter",
		s = { "<Cmd>SnipRun<CR>", "Run snippets" },
	},

	-- Git signs
	h = {
		name = "Git signs",
		b = "Blame line",
		p = "Preview hunk",
		R = "Reset buffer",
		r = "Reset buffer",
		s = "Stage hunk",
		S = "Stage buffer",
		u = "Undo stage hunk",
		U = "Reset buffer index",
	},

	-- Notes
	n = {
		name = "Notes",
		n = {
			"<Cmd>FloatermNew nvim ~/notes/<Cr>",
			"New note",
		},
		o = { "<Cmd>GkeepOpen<Cr>", "GKeep Open" },
		c = { "<Cmd>GkeepClose<Cr>", "GKeep Close" },
		r = { "<Cmd>GkeepRefresh<Cr>", "GKeep Refresh" },
		s = { "<Cmd>GkeepSync<Cr>", "GKeep Sync" },
		p = { "<Cmd>MarkdownPreview<Cr>", "Preview markdown" },
		z = { "<Cmd>ZenMode<Cr>", "Zen Mode" },
		g = { "<Cmd>GrammarousCheck<Cr>", "Grammar check" },
	},

	-- Viewer
	v = {
		name = "View",
		v = { "<Cmd>vsplit term://vd <cfile><CR>", "VisiData" },
	},
}

local lsp_mappings = {

	l = {
		name = "LSP",
		r = { "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
		u = { "<Cmd>Telescope lsp_references<CR>", "References" },
		o = { "<Cmd>Telescope lsp_document_symbols<CR>", "Document symbols" },
		d = { "<Cmd>Telescope lsp_definitions<CR>", "Definition" },
		a = { "<Cmd>Telescope lsp_code_actions<CR>", "Code actions" },
		e = { "<Cmd>lua vim.diagnostic.enable()<CR>", "Enable diagnostics" },
		x = { "<Cmd>lua vim.diagnostic.disable()<CR>", "Disable diagnostics" },
		n = { "<Cmd>update<CR>:Neoformat<CR>", "Neoformat" },
		t = { "<Cmd>TroubleToggle<CR>", "Trouble" },
	},

	-- WIP - refactoring
	-- nnoremap <silent><leader>chd :Lspsaga hover_doc<CR>
	-- nnoremap <silent><C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
	-- nnoremap <silent><C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
	-- nnoremap <silent><leader>cpd:Lspsaga preview_definition<CR>
	-- nnoremap <silent> <leader>cld :Lspsaga show_line_diagnostics<CR>
	-- {'n', '<leader>lds', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>' },
	-- {'n', '<leader>lde', '<cmd>lua vim.diagnostic.enable()<CR>'},
	-- {'n', '<leader>ldd', '<cmd>lua vim.diagnostic.disable()<CR>'},
	-- {'n', '<leader>ll', '<cmd>lua vim.diagnostic.set_loclist()<CR>'},
	-- {'n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>'},
	-- {'v', '<leader>lcr', '<cmd>lua vim.lsp.buf.range_code_action()<CR>'},
}

local dap_nvim_dap_mappings = {
	d = {
		name = "DAP",
		b = { "<Cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
		c = { "<Cmd>lua require('dap').continue()<CR>", "Continue" },
		s = { "<Cmd>lua require('dap').step_over()<CR>", "Step over" },
		i = { "<Cmd>lua require('dap').step_into()<CR>", "Step into" },
		o = { "<Cmd>lua require('dap').step_out()<CR>", "Step out" },
		u = { "<Cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
		p = { "<Cmd>lua require('dap').repl.open()<CR>", "REPL" },
		e = { '<Cmd>lua require"telescope".extensions.dap.commands{}<CR>', "Commands" },
		f = { '<Cmd>lua require"telescope".extensions.dap.configurations{}<CR>', "Configurations" },
		r = { '<Cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', "List breakpoints" },
		v = { '<Cmd>lua require"telescope".extensions.dap.variables{}<CR>', "Variables" },
		m = { '<Cmd>lua require"telescope".extensions.dap.frames{}<CR>', "Frames" },

		-- Refactoring print
		P = { ':lua require("refactoring").debug.printf({below = false})<CR>', "Print" },
		C = { ':lua require("refactoring").debug.cleanup({})<CR>', "Clear print" },
	},
}

function M.register_dap()
	require("which-key").register(dap_nvim_dap_mappings, opts)
end

local lsp_mappings_opts = {
	{
		"document_formatting",
		{ ["lf"] = { "<Cmd>lua vim.lsp.buf.formatting()<CR>", "Format" } },
	},
	{
		"code_lens",
		{
			["ll"] = {
				"<Cmd>lua vim.lsp.codelens.refresh()<CR>",
				"Codelens refresh",
			},
		},
	},
	{
		"code_lens",
		{ ["ls"] = { "<Cmd>lua vim.lsp.codelens.run()<CR>", "Codelens run" } },
	},
}

function M.register_lsp(client)
	local wk = require("which-key")
	wk.register(lsp_mappings, opts)

	for _, m in pairs(lsp_mappings_opts) do
		local capability, key = unpack(m)
		if client.resolved_capabilities[capability] then
			wk.register(key, opts)
		end
	end
end

function M.setup()
	local wk = require("which-key")
	wk.setup({})
	wk.register(mappings, opts)
end

return M
