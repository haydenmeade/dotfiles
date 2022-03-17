local M = {}

local indent = 2
local g = vim.g
local cmd = vim.cmd
local opt = vim.opt

function M.setup()
	-- Map the leader key to SPACE
	vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
	g.mapleader = " "
	g.maplocalleader = ","

	opt.number = true -- line number
	opt.incsearch = true -- search as typing
	opt.hlsearch = true -- highlight matching search
	opt.ignorecase = true -- case insensitive on search..
	opt.smartcase = true -- ..unless there's a capital
	opt.tabstop = indent -- tabsize
	opt.shiftwidth = indent -- tabsize
	opt.softtabstop = indent
	opt.expandtab = true -- use spaces instead of tabs
	opt.autowrite = true -- auto write buffer when it's not focused
	opt.cursorline = true -- enable cursor line
	opt.smarttab = true -- make tab behaviour smarter
	opt.undofile = true -- persistent undo
	opt.termguicolors = true -- true colours for better experience
	opt.termguicolors = true -- true colours for better experience
	opt.inccommand = "split" -- incrementally show result of command
	opt.signcolumn = "yes" -- enable sign column all the time 4 column
	opt.timeoutlen = 300
	opt.updatetime = 300 -- set faster update time
	opt.splitbelow = true
	opt.splitright = true
	opt.clipboard = "unnamed,unnamedplus"
	opt.completeopt = {
		"menu",
		"menuone",
		"noselect",
	} -- better completion
end

M.setup()
