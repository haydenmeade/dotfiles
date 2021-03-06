local util = require("core.util")

local M = {}
local lsp_leader_mappings = {
  l = {
    u = "<Cmd>Telescope lsp_references<CR>",
    o = "<Cmd>Telescope lsp_document_symbols<CR>",
    d = "<Cmd>Telescope lsp_definitions<CR>",
    a = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    e = "<Cmd>lua vim.diagnostic.open_float()<CR>",
    X = "<Cmd>lua vim.diagnostic.enable()<CR>",
    x = "<Cmd>lua vim.diagnostic.disable()<CR>",
    n = "<Cmd>lua require('core.autocmds').toggle_format_on_save()<CR>",
    f = "<Cmd>lua vim.lsp.buf.formatting()<CR>",
    w = "<cmd>Telescope diagnostics<cr>",
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
  ["<C-k>"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
  ["[d"] = "<Cmd>lua vim.diagnostic.goto_prev()<CR>",
  ["]d"] = "<Cmd>lua vim.diagnostic.goto_next()<CR>",
}
function M.register_lsp(buffer)
  util.createmap_buffer("n", lsp_leader_mappings, "<leader>", buffer)
  util.createmap_buffer("n", lsp_buffer_keymappings, nil, buffer)

  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>r", "", {
    expr = true,
    callback = function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end,
  })
end
return M
