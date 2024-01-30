local M = {}

local function lazy_init()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

lazy_init()

require("lazy").setup({
  { "nvim-lua/plenary.nvim", lazy = true },
  { "kyazdani42/nvim-web-devicons", lazy = true },

  -- Development
  { "tpope/vim-repeat", lazy = true },
  { "tpope/vim-surround", lazy = true, event = "BufRead" },
  { "tpope/vim-sleuth", lazy = true },
  { "tpope/vim-abolish", lazy = true },
  {
    "numToStr/Comment.nvim",
    lazy = true,
    config = function()
      require("config.comment").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({ auto_open = false })
    end,
  },
  { "ThePrimeagen/harpoon" },

  { "folke/neodev.nvim", lazy = true },

  --Splits
  { "mrjones2014/smart-splits.nvim", lazy = true },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    lazy = true,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    lazy = true,
  },

  {
    "knubie/vim-kitty-navigator",
    config = function()
      require("config.kitty").setup()
    end,
    build = { "cp ./*.py ~/.config/kitty/" },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    lazy = true,
  },
  {
    "sindrets/diffview.nvim",
    lazy = true,
  },
  {
    "akinsho/git-conflict.nvim",
    lazy = true,
    opts = {
      default_mappings = true, -- disable buffer local mapping created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      highlights = { -- They must have background color, otherwise the default color will be d
        incoming = "DiffText",
        current = "DiffAdd",
      },
    },
  },

  -- Logging
  { "Tastyep/structlog.nvim" },

  -- Sessions
  { "rmagatti/auto-session" },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "ray-x/lsp_signature.nvim", lazy = true },
  { "b0o/schemastore.nvim", lazy = true },
  { "jose-elias-alvarez/null-ls.nvim", lazy = true },
  {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp").setup()
    end,
  },

  {
    "rafamadriz/friendly-snippets",
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    config = function()
      require("config.luasnip").setup()
    end,
    lazy = true,
  },

  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-nvim-lua", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "hrsh7th/cmp-calc", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = true },
  { "octaltree/cmp-look", lazy = true },
  { "f3fora/cmp-spell", lazy = true },
  { "ray-x/cmp-treesitter", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    lazy = true,
    config = function()
      require("config.cmp").setup()
    end,
  },

  { "nvim-treesitter/nvim-treesitter-textobjects" }, -- Syntax aware text-objects, select, move, swap, and peek support.
  { "David-Kunz/treesitter-unit" }, -- Better selection of Treesitter code
  { "nvim-treesitter/nvim-treesitter-refactor" },
  { "RRethy/nvim-treesitter-endwise" }, -- add "end" in Ruby and other languages
  {
    "windwp/nvim-autopairs",
    build = "make",
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
  },

  { "nvim-telescope/telescope-symbols.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-live-grep-raw.nvim" },
  { "benfowler/telescope-luasnip.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.telescope").setup()
    end,
  },

  -- Testing
  {
    "vim-test/vim-test",
    config = function()
      require("config.test").setup()
    end,
  },
  {
    "andythigpen/nvim-coverage",
    config = function()
      require("config.test").coverage()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("config.lualine").setup()
    end,
  },

  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      -- Set to false to disable all of the above keymaps
      _default_keymaps = true,
    },
    lazy = true,
  },
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require("config.theme").setup()
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
  },
})

return M
