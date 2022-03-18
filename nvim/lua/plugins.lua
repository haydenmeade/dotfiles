local M = {}

local packer_bootstrap = false

local function packer_init()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		packer_bootstrap = fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		vim.cmd([[packadd packer.nvim]])
	end
	vim.cmd("autocmd BufWritePost plugins.lua source <afile> | PackerCompile")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer_init()

function M.setup()
	local conf = {
		compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	}

	local function plugins(use)
		use("lewis6991/impatient.nvim")

		use("wbthomason/packer.nvim")

		-- Development
		use({ "tpope/vim-fugitive", event = "BufRead" })
		use({ "tpope/vim-surround", event = "BufRead" })
		use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

		use({
			"numToStr/Comment.nvim",
			event = "VimEnter",
			keys = { "gc", "gcc", "gbc" },
			config = function()
				require("config.comment").setup()
			end,
		})
		use({
			"folke/trouble.nvim",
			event = "VimEnter",
			cmd = { "TroubleToggle", "Trouble" },
			config = function()
				require("trouble").setup({ auto_open = false })
			end,
		})
		-- Go development
		use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
		-- Lua development
		use({ "folke/lua-dev.nvim", event = "VimEnter" })

		-- Git
		use({
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			requires = { "nvim-lua/plenary.nvim" },
			config = function()
				require("gitsigns").setup()
			end,
		})
		use({
			"sindrets/diffview.nvim",
			requires = {
				"kyazdani42/nvim-web-devicons",
				"nvim-lua/plenary.nvim",
			},
			cmd = {
				"DiffviewOpen",
				"DiffviewClose",
				"DiffviewToggleFiles",
				"DiffviewFocusFiles",
			},
		})

		-- Sessions
		use({
			"rmagatti/session-lens",
			requires = { "rmagatti/auto-session" },
			config = function()
				require("config.auto-session").setup()
				require("session-lens").setup({})
			end,
		})

		-- terminal
		use({
			"akinsho/toggleterm.nvim",
			keys = { [[<c-\>]] },
			cmd = { "ToggleTerm", "TermExec" },
			config = function()
				require("config.toggleterm").setup()
			end,
		})

		--LSP
		use("williamboman/nvim-lsp-installer")
		use("jose-elias-alvarez/null-ls.nvim")
		use("ray-x/lsp_signature.nvim")
		use({
			"onsails/lspkind-nvim",
			config = function()
				require("lspkind").init()
			end,
		})
		use({
			"neovim/nvim-lspconfig",
			as = "nvim-lspconfig",
			after = "nvim-treesitter",
			opt = true,
			config = function()
				require("config.lsp").setup()
				require("config.dap").setup()
			end,
		})

		-- DAP
		use({ "mfussenegger/nvim-dap", event = "BufWinEnter", as = "nvim-dap" })
		use({ "mfussenegger/nvim-dap-python", after = "nvim-dap" })
		use({
			"theHamsta/nvim-dap-virtual-text",
			after = "nvim-dap",
			config = function()
				require("nvim-dap-virtual-text").setup({})
			end,
		})
		use({ "rcarriga/nvim-dap-ui", after = "nvim-dap" })
		use({ "Pocco81/DAPInstall.nvim", after = "nvim-dap" })

		-- Snippets
		use({
			"SirVer/ultisnips",
			requires = { { "honza/vim-snippets", rtp = "." } },
			config = function()
				vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
				vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
				vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
				vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
				vim.g.UltiSnipsRemoveSelectModeMappings = 0
			end,
		})

		-- Autocomplete
		use({
			"hrsh7th/nvim-cmp",
			event = { "BufRead", "InsertEnter" },
			opt = true,
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-emoji",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				"quangnguyen30192/cmp-nvim-ultisnips",
				"octaltree/cmp-look",
				"f3fora/cmp-spell",
				"ray-x/cmp-treesitter",
			},
			config = function()
				require("config.cmp").setup()
			end,
		})

		-- Better syntax
		use({
			"nvim-treesitter/nvim-treesitter",
			as = "nvim-treesitter",
			event = "BufRead",
			opt = true,
			run = ":TSUpdate",
			config = function()
				require("config.treesitter").setup()
			end,
			requires = {
				{
					"nvim-treesitter/nvim-treesitter-textobjects",
				},
				{
					"windwp/nvim-autopairs",
					run = "make",
					config = function()
						require("nvim-autopairs").setup({})
					end,
				},
			},
		})

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			module = "telescope",
			as = "telescope",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope-project.nvim",
				"nvim-telescope/telescope-symbols.nvim",
				"fhill2/telescope-ultisnips.nvim",
				"nvim-lua/popup.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				{ "nvim-telescope/telescope-dap.nvim" },
			},
			config = function()
				require("config.telescope").setup()
			end,
		})

		-- Testing
		use({
			"rcarriga/vim-ultest",
			config = "require('config.test').setup()",
			run = ":UpdateRemotePlugins",
			requires = { "vim-test/vim-test" },
		})

		-- Stuff
		use({
			"folke/which-key.nvim",
			config = function()
				require("config.whichkey").setup()
			end,
		})

		use({
			"goolord/alpha-nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = function()
				require("alpha").setup(require("alpha.themes.startify").config)
			end,
		})
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
			after = "nvim-treesitter",
			config = function()
				require("config.lualine").setup()
			end,
		})
		use({
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons", -- optional, for file icon
			},
			config = function()
				require("nvim-tree").setup({})
			end,
		})

		use({
			"akinsho/nvim-bufferline.lua",
			config = function()
				require("config.bufferline").setup()
			end,
			event = "BufReadPre",
		})

		use({
			"SmiteshP/nvim-gps",
			module = "nvim-gps",
			config = function()
				require("nvim-gps").setup()
			end,
		})

		-- Theme
		use({
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({ default = true })
			end,
		})

		use({
			"folke/tokyonight.nvim",
			config = function()
				vim.cmd("colorscheme tokyonight")
			end,
		})
		use({
			"luisiacc/gruvbox-baby",
		})

		if packer_bootstrap then
			print("Setting up Neovim. Restart required after installation!")
			require("packer").sync()
		end
	end

	pcall(require, "impatient")
	local status_ok, _ = pcall(require, "packer_compiled")
	if not status_ok then
		return
	end
	require("packer").init(conf)
	require("packer").startup(plugins)
end
return M
