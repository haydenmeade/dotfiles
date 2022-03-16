local M = {}

local packer_bootstrap = false

local function packer_init()
	local fn = vim.fn
	local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		packer_bootstrap = fn.system {
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		}
		vim.cmd [[packadd packer.nvim]]
	end
	vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
end

packer_init()

function M.setup()
	local conf = {
		compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}

	local function plugins(use)
		use "lewis6991/impatient.nvim"

		use 'wbthomason/packer.nvim'

		--LSP
		use 'williamboman/nvim-lsp-installer'
    use "jose-elias-alvarez/null-ls.nvim"
    use {
      "neovim/nvim-lspconfig",
      as = "nvim-lspconfig",
      after = "nvim-treesitter",
      opt = true,
      config = function()
        require("config.lsp").setup()
      end,
    }

    use {
      "folke/which-key.nvim",
      config = function()
        require("config.whichkey").setup()
      end,
    }

 -- Snippets
    use {
      "SirVer/ultisnips",
      requires = { { "honza/vim-snippets", rtp = "." }},
      config = function()
        vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
        vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
        vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
        vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
        vim.g.UltiSnipsRemoveSelectModeMappings = 0
      end,
    }

    -- Autocomplete
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
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
    }

 -- Go development
    use {'fatih/vim-go', run = ':GoUpdateBinaries' }
 -- Lua development
    use { "folke/lua-dev.nvim", event = "VimEnter" }

    -- Better syntax
    use {
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
            require("nvim-autopairs").setup {}
          end,
        },
      },
    }

    -- Telescope
    use {   
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
      },
      config = function()
        require("config.telescope").setup()
      end,
    }

    -- Testing
    use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

    -- Theme
    use {
      'luisiacc/gruvbox-baby',
      config = function()
        vim.cmd "colorscheme gruvbox-baby"
      end,
    }
    if packer_bootstrap then       
      print "Setting up Neovim. Restart required after installation!"       
      require("packer").sync()     
    end   
end    
pcall(require, "impatient")   
pcall(require, "packer_compiled")   
require("packer").init(conf)   
require("packer").startup(plugins) 
 end 
 return M
