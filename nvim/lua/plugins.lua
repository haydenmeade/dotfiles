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
end

packer_init()

function M.setup()
  -- Packer Config
  local conf = {
    snapshot = packer_snapshot, -- Snapshot name
    snapshot_path = packer_snapshot_path, -- Default save directory for snapshots
    compile_path = join_paths(vim.fn.stdpath "config", "lua", "packer_compiled.lua"),
  }

  local function plugins(use)
    use "lewis6991/impatient.nvim"

    use "nvim-lua/plenary.nvim"
    use "wbthomason/packer.nvim"

    use { "antoinemadec/FixCursorHold.nvim" } -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

    -- Development
    use { "tpope/vim-fugitive", event = "BufRead" }
    use "tpope/vim-repeat"
    use { "tpope/vim-surround", event = "BufRead" }
    use { "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } }
    use { "tpope/vim-sleuth" }

    use {
      "numToStr/Comment.nvim",
      event = "VimEnter",
      config = function()
        require("config.comment").setup()
      end,
    }
    use {
      "folke/trouble.nvim",
      event = "VimEnter",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup { auto_open = false }
      end,
    }
    -- Go development
    -- use "fatih/vim-go"
    use { "darrikonn/vim-gofmt", run = ":GoUpdateBinaries" }
    -- Lua development
    use { "folke/lua-dev.nvim", event = "VimEnter" }

    -- Jumps
    use "ggandor/lightspeed.nvim"

    --Splits
    use "mrjones2014/smart-splits.nvim"

    -- Git
    use {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup()
      end,
    }
    use {
      "sindrets/diffview.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
      },
    }
    use {
      "TimUntersberger/neogit",
      cmd = "Neogit",
      config = function()
        require("config.neogit").setup()
      end,
    }

    -- Legendary
    use {
      "mrjones2014/legendary.nvim",
      keys = { [[<C-p>]] },
      config = function()
        require("config.legendary").setup()
      end,
      requires = { "stevearc/dressing.nvim" },
    }

    -- Logging
    use { "Tastyep/structlog.nvim" }

    -- Sessions
    use {
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session" },
      config = function()
        require("config.auto-session").setup()
        require("session-lens").setup {
          path_display = { "shorten" },
          previewer = true,
        }
      end,
    }

    -- terminal
    use {
      "akinsho/toggleterm.nvim",
      keys = { [[<c-\>]] },
      cmd = { "ToggleTerm", "TermExec" },
      config = function()
        require("config.toggleterm").setup()
      end,
    }

    --LSP
    use {
      "j-hui/fidget.nvim", -- loading progress
      event = "BufReadPre",
      config = function()
        require("fidget").setup {}
      end,
    }
    use "williamboman/nvim-lsp-installer"
    use "jose-elias-alvarez/null-ls.nvim"
    use "ray-x/lsp_signature.nvim"
    use {
      "onsails/lspkind-nvim",
      config = function()
        require("lspkind").init()
      end,
    }
    use {
      "neovim/nvim-lspconfig",
      as = "nvim-lspconfig",
      after = "nvim-treesitter",
      config = function()
        require("lsp").setup()
      end,
    }

    use {
      "rafamadriz/friendly-snippets",
    }

    use {
      "L3MON4D3/LuaSnip",
      requires = "rafamadriz/friendly-snippets",
      config = function()
        require("config.luasnip").setup()
      end,
      after = { "nvim-cmp" },
    }

    -- Autocomplete
    use {
      "hrsh7th/nvim-cmp",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
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
        "octaltree/cmp-look",
        "f3fora/cmp-spell",
        "ray-x/cmp-treesitter",
        "saadparwaiz1/cmp_luasnip",
      },
      after = { "friendly-snippets", "nvim-treesitter" },
      config = function()
        require("config.cmp").setup()
      end,
    }

    -- Better syntax
    use {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufRead", "BufNewFile", "InsertEnter" },
      as = "nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "David-Kunz/treesitter-unit",
        "nvim-treesitter/nvim-treesitter-refactor",
        {
          "nvim-treesitter/playground",
          after = "nvim-treesitter",
          run = ":TSInstall query",
          cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
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

    use {
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
    }

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      as = "telescope",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-symbols.nvim",
        { "cljoly/telescope-repo.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        "benfowler/telescope-luasnip.nvim",
        "nvim-lua/popup.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = function()
        require("config.telescope").setup()
      end,
    }

    -- Testing
    use {
      "rcarriga/vim-ultest",
      config = "require('config.test').setup()",
      run = ":UpdateRemotePlugins",
      requires = { "vim-test/vim-test" },
    }

    -- Stuff
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        require("config.whichkey").setup()
      end,
    }

    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons" },
      after = "nvim-treesitter",
      config = function()
        require("config.lualine").setup()
      end,
    }
    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {
          update_focused_file = {
            enable = true,
          },
          filters = {
            custom = { ".git", "node_modules", ".cargo" },
          },
        }
      end,
    }

    use {
      "akinsho/nvim-bufferline.lua",
      config = function()
        require("config.bufferline").setup()
      end,
      event = "BufReadPre",
    }

    use {
      "SmiteshP/nvim-gps",
      module = "nvim-gps",
      config = function()
        require("nvim-gps").setup()
      end,
    }

    use {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup { default = true }
      end,
    }

    -- Smooth Scrolling
    use {
      "karb94/neoscroll.nvim",
      keys = { "<C-u>", "<C-d>", "gg", "G" },
      config = function()
        require "config.scroll"
      end,
    }
    use {
      "edluffy/specs.nvim",
      after = "neoscroll.nvim",
      config = function()
        require "config.specs"
      end,
    }

    -- ZenMode
    use {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      opt = true,
      wants = "twilight.nvim",
      requires = { "folke/twilight.nvim" },
      config = function()
        require("zen-mode").setup {
          plugins = { gitsigns = true, kitty = { enabled = false, font = "+2" } },
          options = { number = true },
        }
      end,
    }

    -- colorscheme
    use "rebelot/kanagawa.nvim"
    use "luisiacc/gruvbox-baby"
    use {
      "folke/tokyonight.nvim",
      config = function()
        require "config.theme"
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
