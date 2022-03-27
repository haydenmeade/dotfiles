local M = {}

local lsp_providers = {
  "pyright",
  "gopls",
  "sumneko_lua",
  "tsserver",
  "solargraph",
  "clangd",
  "jsonls",
  "bashls",
  "yamlls",
}

local function setup_servers()
  local lsp_installer = require "nvim-lsp-installer"
  local Log = require "core.log"

  require("config.lsp.null-ls").setup()

  lsp_installer.on_server_ready(function(server)
    local ok, server_config = pcall(require, "config.lsp." .. server.name)
    if ok then
      Log:debug("Using custom config for: " .. server.name)
      server:setup(server_config)
    else
      Log:debug("Using default config for: " .. server.name)
      local lsputils = require "config.lsp.utils"
      lsputils.setup_default_server(server)
    end
  end)
end

function M.setup()
  setup_servers()
end

return M
