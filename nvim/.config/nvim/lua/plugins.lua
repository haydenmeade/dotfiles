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
  { "tpope/vim-repeat", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-surround", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-sleuth", event = { "BufReadPost", "BufNewFile" } },
  { "tpope/vim-abolish", event = { "BufReadPost", "BufNewFile" } },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    config = function()
      require("trouble").setup({ auto_open = false })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
      local harpoon = require("harpoon")
      harpoon.setup({})
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {},
    },
  },

  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {
      router = {
        browse = {
          ["ssh.github.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}"
            .. "#L{_A.LSTART}"
            .. "{_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or ''}",
        },
      },
    },
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },

  --Splits
  { "mrjones2014/smart-splits.nvim" },

  {
    "knubie/vim-kitty-navigator",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("config.kitty").setup()
    end,
    build = { "cp ./*.py ~/.config/kitty/" },
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "akinsho/git-conflict.nvim",
    event = { "BufReadPost", "BufNewFile" },
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
  {
    "ray-x/lsp_signature.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  { "b0o/schemastore.nvim" },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "mdformat" },
        cpp = { "clangformat" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 900, lsp_fallback = true }
      end,
      notify_on_error = false,
    },
  },
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
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "linrongbin16/lsp-progress.nvim",
    config = function()
      require("lsp-progress").setup()
    end,
  },

  {
    "rafamadriz/friendly-snippets",
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("config.luasnip").setup()
    end,
  },

  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "f3fora/cmp-spell" },
  { "ray-x/cmp-treesitter" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "yioneko/nvim-cmp",
    event = { "InsertEnter", "VeryLazy" },
    branch = "perf",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "f3fora/cmp-spell" },
      { "ray-x/cmp-treesitter" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      require("config.cmp").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "InsertEnter", "VeryLazy" },
  }, -- Syntax aware text-objects, select, move, swap, and peek support.
  {
    "RRethy/nvim-treesitter-endwise",
    event = { "InsertEnter", "VeryLazy" },
  }, -- add "end" in Ruby and other languages
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "InsertEnter", "VeryLazy" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "VeryLazy" },
    config = function()
      require("copilot").setup({})
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = { "CopilotChat", "CopilotChatToggle" },
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  {
    "ThePrimeagen/refactoring.nvim",
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    config = function()
      require("grug-far").setup({})
    end,
  },
  {
    "mangelozzi/nvim-rgflow.lua",
    config = function()
      require("rgflow").setup({
        default_ui_mappings = true,
        default_quickfix_mappings = true,

        cmd_flags = (
          "--smart-case --fixed-strings --no-fixed-strings --no-ignore -M 500"
          -- Exclude globs
          .. " -g !**/node_modules/"
        ),
      })
    end,
  },

  { "nvim-telescope/telescope-symbols.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("config.telescope").setup()
    end,
  },

  {
    "m4xshen/hardtime.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disabled_filetypes = { "qf", "netrw", "lazy", "oil" },
      disabled_keys = {
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      disable_mouse = false,
    },
  },

  -- Testing
  -- {
  --   "vim-test/vim-test",
  --   cmd = { "TestNearest", "TestFile" },
  -- },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage" },
    config = function()
      require("config.test").coverage()
    end,
  },
  {
    "quolpr/quicktest.nvim",
    config = function()
      local qt = require("quicktest")
      qt.setup({
        adapters = {
          require("quicktest.adapters.golang")({
            additional_args = function()
              return { "-race", "-count=1" }
            end,
          }),
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "m00qek/baleia.nvim",
    },
    keys = function()
      local qt = function()
        return require("quicktest")
      end

      local keys = {
        {
          "<leader>tn",
          function()
            qt().run_line("split")
          end,
          desc = "[T]est Run [Nearest]",
        },
        {
          "<leader>tf",
          function()
            qt().run_file("split")
          end,
          desc = "[T]est [R]un file",
        },
        {
          "<leader>ts",
          function()
            qt().toggle_win("split")
          end,
          desc = "[T]est [S]plit result",
        },

        {
          "<leader>tp",
          function()
            qt().run_previous(qt().run_current("split"))
          end,
          desc = "[T]est [P]revious",
        },
      }

      return keys
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
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
    -- "catppuccin/nvim",
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd([[colorscheme kanagawa]])
    end,
    priority = 1000,
    lazy = false,
  },
}, {
  defaults = {
    lazy = true,
    event = "VeryLazy",
  },
  checker = {
    -- automatically check for plugin updates
    enabled = false,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
  },
  -- Enable profiling of lazy.nvim. This will add some overhead,
  -- so only enable this when you are debugging lazy.nvim
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    loader = false,
    -- Track each new require in the Lazy profiling tab
    require = false,
  },
})

return M
