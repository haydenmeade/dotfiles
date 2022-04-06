local M = {}

function M.setup()
  local ok, ls = h.safe_require "luasnip"
  if not ok then
    return
  end
  local types = require "luasnip.util.types"

  require("luasnip.loaders.from_lua").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load()

  ls.config.set_config {
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,

    updateevents = "TextChanged,TextChangedI",
    region_check_events = "CursorMoved,CursorHold",
    delete_check_events = "InsertLeave",
    enable_autosnippets = true,

    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { " ", "TSTextReference" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "GruvboxBlue" } },
        },
      },
    },
  }

  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end)
end

return M
