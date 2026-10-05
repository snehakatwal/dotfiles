-- lua/lsp/json.lua (Native Neovim without lspconfig plugin)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function(args)
    vim.lsp.start({
      name = "jsonls",
      cmd = { "vscode-json-language-server", "--stdio" },
      root_dir = vim.fs.root(args.buf, { ".git", "package.json" }),
    })
  end,
})
