local M = {}

function M.setup()
  local ok, auto_dark_mode = h.safe_require("auto-dark-mode")
  if not ok then
    return
  end

  auto_dark_mode.setup({
    update_interval = 1000,
    set_dark_mode = function()
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup()
      vim.api.nvim_set_option("background", "dark")
      vim.cmd("colorscheme catppuccin")
    end,
    set_light_mode = function()
      vim.g.catppuccin_flavour = "latte" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup()
      vim.api.nvim_set_option("background", "light")
      -- vim.cmd("colorscheme dayfox")
      vim.cmd("colorscheme catppuccin")
    end,
  })
  auto_dark_mode.init()
end

return M
