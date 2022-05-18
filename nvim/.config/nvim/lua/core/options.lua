local indent = 2
local g = vim.g
local opt = vim.opt

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
opt.inccommand = "split" -- incrementally show result of command
opt.signcolumn = "yes" -- enable sign column all the time 4 column
opt.timeoutlen = 300
opt.updatetime = 300 -- set faster update time
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamed,unnamedplus"

-- For windows:
vim.api.nvim_exec(
  [[
if has("win64") || has("win32")
  let g:clipboard = {
        \   'name': 'win32yank',
        \   'copy': {
        \      '+': 'win32yank.exe -i',
        \      '*': 'win32yank.exe -i',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o',
        \      '*': 'win32yank.exe -o',
        \   },
        \   'cache_enabled': 0,
        \ }
  " see ':h shell-powershell' and
  " https://github.com/junegunn/vim-plug/issues/895#issuecomment-544130552
  let &shell = has('win64') ? 'pwsh.exe': 'powershell.exe'
  set shellquote= shellpipe=\| shellxquote=
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellredir=\|\ Out-File\ -Encoding\ UTF8
endif
]] ,
  true
)

-- Lua filetype detection mechanism
g.do_filetype_lua = 1
-- disable filetype.vim and use only filetype.lua (at your own risk)
g.did_load_filetypes = 0
g.loaded_perl_provider = 0

opt.sessionoptions = "buffers,curdir,folds,help,winsize,winpos,terminal"
opt.lazyredraw = true --When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen, which greatly speeds it up, upto 6-7x faster
opt.shortmess:append "sI" -- disable nvim intro
opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
} -- better completion

-- disable some builtin vim plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
