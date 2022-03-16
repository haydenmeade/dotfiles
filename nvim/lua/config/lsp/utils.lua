local M = {}

local lsp_keymappings = {

  normal_mode = {
    ["K"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
    ["gD"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
    ["<C-k>"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    ["[d"] = "<Cmd>lua vim.diagnostic.goto_prev()<CR>",
    ["]d"] = "<Cmd>lua vim.diagnostic.goto_next()<CR>",
    ["[e"] = "<Cmd>Lspsaga diagnostic_jump_next<CR>",
    ["]e"] = "<Cmd>Lspsaga diagnostic_jump_prev<CR>",
  },
}

function M.lsp_config(client, bufnr)

  -- Key mappings
  local keymap = require "utils.keymap"
  for mode, mapping in pairs(lsp_keymappings) do
    keymap.map(mode, mapping)
  end

  -- LSP and DAP menu
  local whichkey = require "config.whichkey"
  whichkey.register_lsp(client)

  if client.name == "tsserver" or client.name == "jsonls" then
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  if client.resolved_capabilities.document_formatting then
    vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
  end
end

function M.lsp_attach(client, bufnr)
  M.lsp_config(client, bufnr)
end

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- for nvim-cmp
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  -- Code actions
  capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = (function()
          local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
          table.sort(res)
          return res
        end)(),
      },
    },
  }
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return capabilities
end

function M.setup_server(server, config)
  local options = {
    on_attach = M.lsp_attach,
    capabilities = M.get_capabilities(),
    flags = { debounce_text_changes = 150 },
  }
  for k, v in pairs(config) do
    options[k] = v
  end

  local lspconfig = require "lspconfig"
  lspconfig[server].setup(vim.tbl_deep_extend("force", options, {}))

  local cfg = lspconfig[server]
  if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
    print(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
  end
end

return M
