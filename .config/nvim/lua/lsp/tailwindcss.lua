-- File: tailwind-lsp.lua
local util = require("vim.lsp.util")

local config = {
  name = 'tailwindcss',
  cmd = { 'tailwindcss-language-server', '--stdio' },
  root_dir = vim.fn.getcwd(), -- or set manually
  filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'css' },
  settings = {
    tailwindCSS = {
      classAttributes = { 'class', 'className' },
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
      },
      experimental = {
        classRegex = {
          { "tw`([^`]*)", 1 },
          { 'tw="([^"]*)', 1 },
        }
      },
    },
  },
  before_init = function(_, cfg)
    if not cfg.settings.editor then cfg.settings.editor = {} end
    cfg.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
  end,
}

-- Start the LSP manually
vim.api.nvim_create_autocmd("FileType", {
  pattern = config.filetypes,
  callback = function(args)
    vim.lsp.start({
      name = config.name,
      cmd = config.cmd,
      root_dir = config.root_dir,
      settings = config.settings,
      before_init = config.before_init,
      on_attach = config.on_attach,
    })
  end
})
