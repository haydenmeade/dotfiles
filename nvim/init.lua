require("plugin").setup()

local u = require "util"
local nnoremap = u.nnoremap

-- test
vim.g.ultest_use_pty = 1

-- Better movement between windows
nnoremap("<C-h>", "<C-w><C-h>", { desc = "Go to the left window" })
nnoremap("<C-l>", "<C-w><C-l>", { desc = "Go to the right window" })
nnoremap("<C-j>", "<C-w><C-j>", { desc = "Go to the bottom window" })
nnoremap("<C-k>", "<C-w><C-k>", { desc = "Go to the top window" })

require 'telescope'
require 'nvim-treesitter'
require 'lua-dev'
