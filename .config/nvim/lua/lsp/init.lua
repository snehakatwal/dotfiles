vim.lsp.config("*", {
  root_markers = { ".git" },
})

require("lsp.lua_ls")
require("lsp.ts_ls")
require("lsp.tailwindcss")
require("lsp.python").setup()
require("lsp.emmet_ls")
require("lsp.json")
