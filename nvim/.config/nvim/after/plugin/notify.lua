local ok, notify = h.safe_require "notify"
if not ok then
  return
end
notify.setup {
  stages = "slide",
  timeout = 3000,
}
vim.notify = notify
