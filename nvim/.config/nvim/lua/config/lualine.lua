local M = {}

function M.setup()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then
    local Log = require "core.log"
    Log:debug "headless mode detected, skipping running setup for lualine"
    return
  end

  local ok, lualine = h.safe_require "lualine"
  if not ok then
    return
  end
  local ok, gps = h.safe_require "nvim-gps"
  if not ok then
    return
  end

  -- Color table for highlights
  local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand "%:p:h"
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  local components = {

    mode = {
      -- mode component
      function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.red,
          i = colors.green,
          v = colors.blue,
          [""] = colors.blue,
          V = colors.blue,
          c = colors.magenta,
          no = colors.red,
          s = colors.orange,
          S = colors.orange,
          [""] = colors.orange,
          ic = colors.yellow,
          R = colors.violet,
          Rv = colors.violet,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.red,
        }
        vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
        return ""
      end,
      color = "LualineMode",
      left_padding = 0,
    },

    filename = {
      "filename",
      condition = conditions.buffer_not_empty,
      path = 1,
      shorting_target = 40,
      color = { fg = colors.magenta, gui = "bold" },
    },

    location = { "location" },

    progress = { "progress", color = { fg = colors.fg, gui = "bold" } },

    diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      color_error = colors.red,
      color_warn = colors.yellow,
      color_info = colors.cyan,
    },

    gps = {
      gps.get_location,
      cond = gps.is_available,
    },

    percent = {
      function()
        return "%="
      end,
    },

    lsp = {
      -- Lsp server name .
      function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return msg
        end
        local client_names = {}
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            client_names[client.name] = true
          end
        end
        if next(client_names) then
          local names = ""
          for k, _ in pairs(client_names) do
            if names == "" then
              names = k
            else
              names = names .. "," .. k
            end
          end
          return names
        end
        return msg
      end,
      icon = " LSP:",
      color = { fg = colors.violet, gui = "bold" },
    },

    filesize = {
      -- filesize component
      function()
        local function format_file_size(file)
          local size = vim.fn.getfsize(file)
          if size <= 0 then
            return ""
          end
          local sufixes = { "b", "k", "m", "g" }
          local i = 1
          while size > 1024 do
            size = size / 1024
            i = i + 1
          end
          return string.format("%.1f%s", size, sufixes[i])
        end

        local file = vim.fn.expand "%:p"
        if string.len(file) == 0 then
          return ""
        end
        return format_file_size(file)
      end,
      condition = conditions.buffer_not_empty,
    },

    -- Add components to right sections
    encoding = {
      "o:encoding", -- option component same as &encoding in viml
      upper = true, -- I'm not sure why it's upper case either ;)
      condition = conditions.hide_in_width,
      color = { fg = colors.green, gui = "bold" },
    },

    branch = {
      "branch",
      icon = "",
      condition = conditions.check_git_workspace,
      color = { fg = colors.violet, gui = "bold" },
    },

    diff = {
      "diff",
      -- Is it me or the symbol for modified us really weird
      symbols = { added = " ", modified = "柳 ", removed = " " },
      color_added = colors.green,
      color_modified = colors.orange,
      color_removed = colors.red,
      condition = conditions.hide_in_width,
    },

    scrollbar = {
      function()
        local current_line = vim.fn.line "."
        local total_lines = vim.fn.line "$"
        local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
        local line_ratio = current_line / total_lines
        local index = math.ceil(line_ratio * #chars)
        return chars[index]
      end,
      padding = { left = 0, right = 0 },
      color = { fg = colors.yellow, bg = colors.bg },
      cond = nil,
    },
  }

  -- Config
  local config = {
    options = {
      -- Disable sections and component separators
      component_separators = "",
      section_separators = "",
      theme = "auto",
      disabled_filetypes = { "alpha", "NvimTree", "Outline" },
    },
    sections = {
      lualine_a = { components.mode },
      lualine_b = { components.filename },
      lualine_c = { components.gps },
      lualine_x = { components.diagnostics, components.lsp },
      lualine_y = { components.diff },
      lualine_z = { components.location, components.scrollbar },
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = { components.filename },
      lualine_v = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
    tabline = {},
    extensions = { "nvim-tree" },
  }

  -- Now don't forget to initialize lualine
  lualine.setup(config)
end

return M
