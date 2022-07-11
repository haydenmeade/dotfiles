local M = {}
local Log = require("core.log")

function M.luaconfig()
  return {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  }
end

function M.config()
  local lua_dev_loaded, lua_dev = pcall(require, "lua-dev")
  if not lua_dev_loaded then
    Log:debug("Lua-dev not loaded")
    return {}
  end

  local dev_opts = {
    library = {
      vimruntime = true, -- runtime path
      types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
      -- plugins = true, -- installed opt or start plugins in packpath
      -- you can also specify the list of plugins to make available as a workspace library
      plugins = true,
    },

    lspconfig = M.luaconfig(),
  }
  return lua_dev.setup(dev_opts)
end

return M
