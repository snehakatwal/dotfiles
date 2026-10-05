-- Use locals for better organization
local api = vim.api
local opt = vim.opt
local g = vim.g
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local filetype = vim.filetype
-- Always show the statusline
opt.showmode = true
g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- General settings
opt.scrolloff = 4
g.vim_be_good_log_file = 1
opt.autoread = true
opt.autowriteall = false
opt.showcmd = false
opt.laststatus = 2
opt.formatoptions:remove({ "c", "r", "o" })
opt.cursorline = true
opt.number = true
opt.title = true
opt.backspace = "2"
opt.hlsearch = true
opt.ignorecase = false

-- Backup and swapfile settings
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Split window behavior
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

-- Indentation settings
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.shiftround = true
opt.expandtab = true

-- Netrw settings
g.loaded_netrw = 0
g.loaded_netrwPlugin = 0

-- Clipboard settings
opt.clipboard:append("unnamedplus")

-- Word wrapping settings
opt.wrap = true
opt.linebreak = true

-- Relative line numbers
opt.relativenumber = true
g.netrw_syntax_highlight = 0
-- Filetype customization
filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  return vim.lsp.handlers.hover(err, result, ctx, vim.tbl_extend("force", config or {}, {
    border = "single",
  }))
end

vim.o.showtabline = 2

vim.opt.termguicolors = true
vim.diagnostic.config({ virtual_text = true }) -- Disable default virtual text
