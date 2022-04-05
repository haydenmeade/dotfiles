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
    -- snapshot = packer_snapshot, -- Snapshot name
    -- snapshot_path = packer_snapshot_path, -- Default save directory for snapshots
    -- compile_path = join_paths(vim.fn.stdpath "config", "lua", "packer_compiled.lua"),
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
    -- use { "darrikonn/vim-gofmt", run = ":GoUpdateBinaries" }
    use {
      "ray-x/go.nvim",
      config = function()
        require("go").setup {
          test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
          run_in_floaterm = false, -- set to true to run in float window.
          --float term recommand if you use richgo/ginkgo with terminal color
          dap_debug = true, -- set to true to enable dap
          dap_debug_keymap = false, -- set keymaps for debugger
          dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
          dap_debug_vt = true, -- set to true to enable dap virtual text
          -- Disable everything for LSP
          lsp_cfg = false, -- true: apply go.nvim non-default gopls setup
          lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
          lsp_on_attach = false, -- if a on_attach function provided:  attach on_attach function to gopls
          gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile", "/var/log/gopls.log" }
        }
      end,
    }
    -- Lua development
    use { "folke/lua-dev.nvim", event = "VimEnter" }

    -- Debug adapter protocol
    use "mfussenegger/nvim-dap"
    use "rcarriga/nvim-dap-ui"
    use "theHamsta/nvim-dap-virtual-text"
    use "nvim-telescope/telescope-dap.nvim"

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
        "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
        "JoosepAlviste/nvim-ts-context-commentstring",
        "David-Kunz/treesitter-unit", -- Better selection of Treesitter code
        "nvim-treesitter/nvim-treesitter-refactor",
        "RRethy/nvim-treesitter-endwise", -- add "end" in Ruby and other languages
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
    use {
      "andythigpen/nvim-coverage", -- Display test coverage information
      module = "coverage",
      config = function()
        require("config.test").coverage()
      end,
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

    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("config.indent-blankline").setup()
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
    use "olimorris/onedarkpro.nvim"
    use "rebelot/kanagawa.nvim"
    use "luisiacc/gruvbox-baby"
    use "eddyekofo94/gruvbox-flat.nvim"
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
