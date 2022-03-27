local autocmd = vim.api.nvim_create_autocmd
-- Highlight on yank
autocmd("TextYankPost", { callback = vim.highlight.on_yank })

-- cursorline only in normal mode
autocmd("InsertLeave,WinEnter", { command = "set cursorline" })
autocmd("InsertEnter,WinLeave", { command = "set nocursorline" })

vim.cmd [[
        set wildmode=longest,list,full
        set wildoptions=pum
        set wildmenu
        set wildignore+=*.pyc
        set wildignore+=*_build/*
        set wildignore+=**/coverage/*
        set wildignore+=**/node_modules/*
        set wildignore+=**/android/*
        set wildignore+=**/ios/*
        set wildignore+=**/.git/*
    ]]

vim.cmd [[ command! BufferKill lua require('config.bufferline').buf_kill('bd') ]]

-- don't auto comment new lines
autocmd("BufEnter", { command = "set fo-=c fo-=r fo-=o" })

vim.api.nvim_exec(
  [[
        cnoreabbrev W! w!
        cnoreabbrev Q! q!
        cnoreabbrev Qall! qall!
        cnoreabbrev Wq wq
        cnoreabbrev Wa wa
        cnoreabbrev wQ wq
        cnoreabbrev WQ wq
        cnoreabbrev W w
        cnoreabbrev Q q
        cnoreabbrev Qall qall
    ]],
  false
)

-- Terminal
vim.api.nvim_exec(
  [[
        augroup auto_term
            autocmd!
            autocmd TermOpen * setlocal nonumber norelativenumber
            autocmd TermOpen * startinsert
        augroup END
    ]],
  false
)
