local venv = require("config.python-venv")

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      venv.activate()

      local clients = vim.lsp.get_clients({ name = "pyright" })
      if #clients > 0 then
        return
      end

      local settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      }

      if vim.env.VIRTUAL_ENV then
        settings.python.pythonPath = vim.env.VIRTUAL_ENV .. "/bin/python"
        settings.python.venvPath = vim.fs.dirname(vim.env.VIRTUAL_ENV)
      end

      vim.lsp.start({
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = vim.fs.dirname(vim.fs.find({
          "pyproject.toml", ".git", "setup.py",
          "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json"
        }, { upward = true })[1]),
        settings = settings,
      })
    end,
  })
end

return M
