require("config.options")
require("config.python-venv")
require("lsp")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

-- 1. Automatically detect OS extension (.dylib for macOS, .so for Linux, .dll for Windows)
local ext = ".so"
if vim.uv.os_uname().sysname == "Darwin" then
  ext = ".dylib"
elseif vim.uv.os_uname().sysname == "Windows_NT" then
  ext = ".dll"
end

-- 2. Define path to your compiled parsers
local parser_dir = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "share", "tree-sitter")

-- Helper function to load parsers cleanly
local function load_parser(lang, rel_path)
  local full_path = vim.fs.joinpath(parser_dir, rel_path .. ext)
  -- Only attempt to load if the file actually exists on this system
  if vim.uv.fs_stat(full_path) then
    vim.treesitter.language.add(lang, { path = full_path })
  end
end

-- 3. Load All Your Compiled Parsers
load_parser('tsx', 'tree-sitter-typescript/tsx/parser')
load_parser('typescript', 'tree-sitter-typescript/typescript/parser')
load_parser('javascript', 'tree-sitter-javascript/javascript')
load_parser('python', 'tree-sitter-python')
load_parser('html', 'tree-sitter-html/html')
load_parser('css', 'tree-sitter-css/css')
load_parser('json', 'tree-sitter-json/json')

-- 4. Map Filetypes to Parsers
-- Tells Neovim to use 'tsx' parser for TSX, JSX, and React files
vim.treesitter.language.register('tsx', { 'typescriptreact', 'javascriptreact', 'jsx' })

-- 5. Auto-start Treesitter Highlighting & Folding when opening files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Start Native Treesitter Highlighting',
  callback = function(args)
    -- Determine parser language for current buffer
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft

    -- Try starting Treesitter highlighting
    local status, _ = pcall(vim.treesitter.start, args.buf, lang)
    if status then
      -- Optional: Enable native Treesitter code folding
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldenable = false -- Keeps folds open by default when opening files
    end
  end,
})

-- 5. Insert Mode Abbreviations
vim.cmd([[
  " Number replacements
  iabbrev one 1
  iabbrev two 2
  iabbrev three 3
  iabbrev four 4
  iabbrev seven 7

  " Symbol replacements
  iabbrev exclam !
  iabbrev atsym @
  iabbrev hash #
  iabbrev dollar $
  iabbrev andsym &
]])

-- 6. Default LSP Configuration
vim.lsp.config("*", {
  root_markers = { ".git" },
})
