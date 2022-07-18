local M = {}

function M.setup()
  local ok, auto_dark_mode = h.safe_require("auto-dark-mode")
  if not ok then
    return
  end

  auto_dark_mode.setup({
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option("background", "dark")
      vim.cmd("colorscheme tokyonight")
    end,
    set_light_mode = function()
      vim.api.nvim_set_option("background", "light")
      vim.cmd("colorscheme dayfox")
    end,
  })
  auto_dark_mode.init()
end

return M
