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

-- typos
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

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

vim.api.nvim_create_user_command("FormatToggle", function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
    Log:debug("Enabled format on save")
  else
    vim.g.disable_autoformat = true
    Log:debug("Disabled format on save")
  end
end, {
  desc = "toggle autoformat-on-save",
})

local numbertogglegroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
  group = numbertogglegroup,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
  group = numbertogglegroup,
})

return M
