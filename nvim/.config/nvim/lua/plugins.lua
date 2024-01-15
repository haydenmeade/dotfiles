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
end

packer_init()

function M.setup()
  local function plugins(use)
    use("lewis6991/impatient.nvim")

    use("nvim-lua/plenary.nvim")
    use("wbthomason/packer.nvim")

    use({ "antoinemadec/FixCursorHold.nvim" }) -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

    -- notify override
    -- use "rcarriga/nvim-notify"

    -- Development
    use("tpope/vim-repeat")
    use({ "tpope/vim-surround", event = "BufRead" })
    use({ "tpope/vim-sleuth" })
    use("tpope/vim-abolish") -- :%S/abc/bac/

    use({
      "numToStr/Comment.nvim",
      config = function()
        require("config.comment").setup()
      end,
    })
    use({
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup({ auto_open = false })
      end,
    })
    use({
      "ThePrimeagen/harpoon",
      requires = { "nvim-lua/plenary.nvim" },
    })

    -- Go development
    -- use({
    --   "ray-x/go.nvim",
    --   config = function()
    --     require("go").setup({
    --       test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
    --       run_in_floaterm = false, -- set to true to run in float window.
    --       --float term recommand if you use richgo/ginkgo with terminal color
    --       dap_debug = true, -- set to true to enable dap
    --       dap_debug_keymap = false, -- set keymaps for debugger
    --       dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
    --       dap_debug_vt = true, -- set to true to enable dap virtual text
    --       -- Disable everything for LSP
    --       lsp_cfg = false, -- true: apply go.nvim non-default gopls setup
    --       lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
    --       lsp_on_attach = false, -- if a on_attach function provided:  attach on_attach function to gopls
    --       gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile", "/var/log/gopls.log" }
    --     })
    --   end,
    -- })
    -- Lua development
    use({
      "folke/neodev.nvim",
      config = function()
        require("neodev").setup({
          -- add any options here, or leave empty to use the default settings
        })
      end,
    })

    -- Debug adapter protocol
    -- use "mfussenegger/nvim-dap"
    -- use "rcarriga/nvim-dap-ui"
    -- use "theHamsta/nvim-dap-virtual-text"
    -- use "nvim-telescope/telescope-dap.nvim"

    -- Jumps
    -- Maybe use this another time
    -- use "ggandor/lightspeed.nvim"

    --Splits
    use("mrjones2014/smart-splits.nvim")

    use({
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    })
    use({
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end,
    })

    -- kitty
    use({
      "knubie/vim-kitty-navigator",
      config = function()
        require("config.kitty").setup()
      end,
      run = { "cp ./*.py ~/.config/kitty/" },
    })

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
    })
    use({
      "akinsho/git-conflict.nvim",
      config = function()
        require("git-conflict").setup({
          default_mappings = true, -- disable buffer local mapping created by this plugin
          disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
          highlights = { -- They must have background color, otherwise the default color will be used
            incoming = "DiffText",
            current = "DiffAdd",
          },
        })
      end,
    })

    -- use({
    --   "ldelossa/gh.nvim",
    --   requires = { { "ldelossa/litee.nvim" } },
    --   config = function()
    --     require("litee.lib").setup({})
    --     require("litee.gh").setup({})
    --   end,
    -- })

    -- use({
    --   "pwntester/octo.nvim",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --     "nvim-telescope/telescope.nvim",
    --     "kyazdani42/nvim-web-devicons",
    --   },
    --   config = function()
    --     require("config.octo").setup()
    --   end,
    -- })

    -- Logging
    use({ "Tastyep/structlog.nvim" })

    -- Sessions
    use({
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session" },
      config = function()
        require("config.auto-session").setup()
        require("session-lens").setup({
          path_display = { "shorten" },
          previewer = true,
        })
      end,
    })

    --LSP
    -- use({
    --   "j-hui/fidget.nvim", -- loading progress
    --   event = "BufReadPre",
    --   config = function()
    --     require("fidget").setup({})
    --   end,
    -- })

    use({
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    })
    use("ray-x/lsp_signature.nvim")
    use("b0o/schemastore.nvim")
    use("jose-elias-alvarez/null-ls.nvim")
    use({
      "onsails/lspkind-nvim",
      config = function()
        require("lspkind").init()
      end,
    })
    use({
      "neovim/nvim-lspconfig",
      config = function()
        require("lsp").setup()
      end,
    })

    use({
      "rafamadriz/friendly-snippets",
    })

    use({
      "L3MON4D3/LuaSnip",
      tag = "v2.*",
      run = "make install_jsregexp",
      requires = "rafamadriz/friendly-snippets",
      config = function()
        require("config.luasnip").setup()
      end,
      after = { "nvim-cmp", "nvim-treesitter" },
    })

    -- Autocomplete
    use({
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
    })

    -- Better syntax
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
        "David-Kunz/treesitter-unit", -- Better selection of Treesitter code
        "nvim-treesitter/nvim-treesitter-refactor",
        "RRethy/nvim-treesitter-endwise", -- add "end" in Ruby and other languages
        {
          "nvim-treesitter/playground",
          after = "nvim-treesitter",
          run = ":TSInstall query",
          opt = true,
          cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
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
    use("nvim-treesitter/nvim-treesitter-context")

    use({
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        require("refactoring").setup({})
      end,
    })

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-symbols.nvim",
        "cljoly/telescope-repo.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-live-grep-raw.nvim",
        "benfowler/telescope-luasnip.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-lua/popup.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = function()
        require("config.telescope").setup()
      end,
    })

    -- Testing
    use({
      "vim-test/vim-test",
      config = "require('config.test').setup()",
    })
    use({
      "andythigpen/nvim-coverage", -- Display test coverage information
      config = function()
        require("config.test").coverage()
      end,
    })
    -- use("rcarriga/neotest-vim-test")
    -- use("akinsho/neotest-go")
    -- use("nvim-neotest/neotest-plenary")
    -- use("haydenmeade/neotest-jest")
    -- use({
    --   "rcarriga/neotest",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --     "nvim-treesitter/nvim-treesitter",
    --     "antoinemadec/FixCursorHold.nvim",
    --   },
    -- })

    -- use({
    --   "folke/which-key.nvim",
    --   event = "VimEnter",
    --   config = function()
    --     require("config.whichkey").setup()
    --   end,
    -- })

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
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({
          disable_netrw = true,
          update_focused_file = {
            enable = true,
          },
          filters = {
            custom = { ".git", "node_modules", ".cargo" },
          },
        })
      end,
    })

    use({
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({ default = true })
      end,
    })

    -- Smooth Scrolling
    -- use({
    --   "karb94/neoscroll.nvim",
    --   keys = { "<C-u>", "<C-d>", "gg", "G" },
    --   config = function()
    --     require("config.scroll")
    --   end,
    -- })

    -- use({
    --   "lukas-reineke/indent-blankline.nvim",
    --   config = function()
    --     require("config.indent-blankline").setup()
    --   end,
    -- })
    -- colorschemes
    -- use "olimorris/onedarkpro.nvim"
    -- use "rebelot/kanagawa.nvim"
    -- use "luisiacc/gruvbox-baby"
    -- use "eddyekofo94/gruvbox-flat.nvim"
    -- use("EdenEast/nightfox.nvim")
    -- use("Shatur/neovim-ayu")
    -- use("folke/tokyonight.nvim")
    -- use("sainnhe/edge")
    -- use "Mofiqul/dracula.nvim"
    use({
      "f-person/auto-dark-mode.nvim",
      config = function()
        require("config.theme").setup()
      end,
    })
    -- use {
    --   "rose-pine/neovim",
    --   as = "rose-pine",
    -- }
    use({
      "catppuccin/nvim",
      as = "catppuccin",
    })

    if packer_bootstrap then
      print("Setting up Neovim. Restart required after installation!")
      require("packer").sync()
    end
  end

  pcall(require, "impatient")
  pcall(require, "packer_compiled")
  require("packer").init({ max_jobs = 50 })
  require("packer").startup(plugins)
end

return M
