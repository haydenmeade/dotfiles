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
  { "nvim-lua/plenary.nvim" },
  { "kyazdani42/nvim-web-devicons" },

  -- Development
  { "tpope/vim-repeat", event = "BufReadPre" },
  { "tpope/vim-surround", event = "BufReadPre" },
  { "tpope/vim-sleuth", event = "BufReadPre" },
  { "tpope/vim-abolish", event = "BufReadPre" },

  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = function()
      require("config.comment").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({ auto_open = false })
    end,
  },

  { "ThePrimeagen/harpoon" },

  { "folke/neodev.nvim" },

  --Splits
  { "mrjones2014/smart-splits.nvim" },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
  },

  {
    "knubie/vim-kitty-navigator",
    event = "BufReadPre",
    config = function()
      require("config.kitty").setup()
    end,
    build = { "cp ./*.py ~/.config/kitty/" },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    version = "*",
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    version = "*",
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
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      })
    end,
  },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "b0o/schemastore.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    version = "*",
    config = function()
      require("lsp").setup()
    end,
    event = { "BufReadPre", "BufNewFile" },
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
  },

  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "octaltree/cmp-look" },
  { "f3fora/cmp-spell" },
  { "ray-x/cmp-treesitter" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "hrsh7th/nvim-cmp",
    event = "BufReadPre",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "octaltree/cmp-look" },
      { "f3fora/cmp-spell" },
      { "ray-x/cmp-treesitter" },
      { "saadparwaiz1/cmp_luasnip" },
    },
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
    event = "BufReadPre",
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
    cmd = { "TestNearest", "TestFile" },
    config = function()
      require("config.test").setup()
    end,
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      require("config.test").coverage()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPre",
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
      _default_keymaps = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd([[colorscheme catppuccin]])
    end,
    priority = 1000,
    lazy = false,
  },
}, {
  defaults = {
    lazy = true,
    event = "VeryLazy",
  },
})

return M
