local M = {}
local M = {}
local M = {}

local Log = require("core.log")
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
-- autocmd("TextYankPost", { callback = vim.highlight.on_yank })
vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank()]])

-- cursorline only in normal mode
-- autocmd("InsertLeave,WinEnter", { command = "set cursorline" })
-- autocmd("InsertEnter,WinLeave", { command = "set nocursorline" })

vim.cmd([[ command! BufferKill lua require('config.bufferline').buf_kill('bd') ]])

-- don't auto comment new lines
autocmd("BufEnter", { command = "set fo-=c fo-=r fo-=o" })

-- Force write shada on leaving nvim
autocmd("VimLeave", { command = [[if has('nvim') | wshada! | else | wviminfo! | endif]] })

-- Check if file changed when its window is focus, more eager than 'autoread'
autocmd("FocusGained", { command = "checktime" })

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
            " autocmd TermOpen * startinsert
        augroup END
    ]],
  false
)

local format_on_save = true

vim.api.nvim_create_user_command("FormatDocumentH", function() end, {})

function M.configure_format_on_save()
  local augid = vim.api.nvim_create_augroup("user_lsp_fmt_on_save", { clear = true })
  if format_on_save then
    vim.api.nvim_create_autocmd("BufWritePre", {
      command = "FormatDocumentH",
      group = augid,
    })
    Log:debug("enabled format-on-save")
  else
    Log:debug("disabled format-on-save")
  end
end

function M.toggle_format_on_save()
  format_on_save = not format_on_save
  M.configure_format_on_save()
end

return M
