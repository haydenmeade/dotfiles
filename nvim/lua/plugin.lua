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
  use { "lewis6991/impatient.nvim" }

	-- Packer can manage itself   
	use 'wbthomason/packer.nvim'

	--LSP
	use {'neovim/nvim-lspconfig',
	    'williamboman/nvim-lsp-installer',
    }

	-- Autocomplete
				use 'hrsh7th/cmp-nvim-lsp'
				use 'hrsh7th/cmp-buffer'
				use 'hrsh7th/cmp-path'
				use 'hrsh7th/cmp-cmdline'
				use 'hrsh7th/nvim-cmp'

				use 'hrsh7th/cmp-vsnip'
				use 'hrsh7th/vim-vsnip'

	use {'fatih/vim-go', run = ':GoUpdateBinaries' }

	--Neovim Tree shitter 
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	-- Search
	-- Telescope
	use {   'nvim-telescope/telescope.nvim',   requires = { {'nvim-lua/plenary.nvim'} } }
	use 'nvim-telescope/telescope-fzy-native.nvim'

	-- Testing
	use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }

	-- Theme
	use 'luisiacc/gruvbox-baby'
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
