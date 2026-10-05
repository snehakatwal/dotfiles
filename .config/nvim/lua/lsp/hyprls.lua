vim.lsp.config('hyprls', {
  cmd = { 'hyprls' },
  filetypes = { 'hyprlang' },
  root_markers = { '.git' },
})

vim.lsp.enable('hyprls')
