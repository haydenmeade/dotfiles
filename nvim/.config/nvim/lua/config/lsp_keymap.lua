local util = require("core.util")

local M = {}
local lsp_leader_mappings = {
  l = {
    u = "<Cmd>FzfLua lsp_references<CR>",
    o = "<Cmd>FzfLua lsp_document_symbols<CR>",
    d = "<Cmd>FzfLua lsp_definitions<CR>",
    a = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    e = "<Cmd>lua vim.diagnostic.open_float()<CR>",
    X = "<Cmd>lua vim.diagnostic.enable()<CR>",
    x = "<Cmd>lua vim.diagnostic.disable()<CR>",
    n = "<Cmd>FormatToggle<CR>",
    f = "<Cmd>lua vim.lsp.buf.formatting()<CR>",
    w = "<cmd>FzfLua diagnostics_workspace<cr>",
  },
}

local lsp_buffer_keymappings = {
  K = "<Cmd>lua vim.lsp.buf.hover()<CR>",
  g = {
    D = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    d = "<Cmd>lua vim.lsp.buf.definition()<CR>",
    i = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    r = "<Cmd>lua vim.lsp.buf.references()<CR>",
  },
  ["[d"] = "<Cmd>lua vim.diagnostic.goto_prev()<CR>",
  ["]d"] = "<Cmd>lua vim.diagnostic.goto_next()<CR>",
  ["<leader>r"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
  ["<leader><leader>"] = "<Cmd>Format<CR>",
}

function M.register_lsp(buffer)
  util.createmap_buffer("n", lsp_leader_mappings, "<leader>", buffer)
  util.createmap_buffer("n", lsp_buffer_keymappings, nil, buffer)
end

return M
