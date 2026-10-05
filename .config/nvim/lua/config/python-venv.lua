local M = {}

local venv_names = { ".venv", "venv", "virtualenv", "env" }

--- Find a virtual environment directory starting from the current file's directory
function M.find_venv()
  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" then
    return nil
  end

  local venv_path = vim.fs.find(venv_names, { upward = true, path = buf_dir, type = "directory" })
  if #venv_path > 0 then
    return venv_path[1]
  end

  return nil
end

--- Activate the virtual environment by setting environment variables
function M.activate()
  local venv = M.find_venv()
  if not venv then
    return
  end

  local bin_dir = venv .. "/bin"
  local python_path = bin_dir .. "/python"

  if vim.fn.isdirectory(bin_dir) == 0 then
    return
  end

  vim.env.VIRTUAL_ENV = venv

  -- Prepend venv bin to PATH if not already there
  if not vim.env.PATH:find(bin_dir, 1, true) then
    vim.env.PATH = bin_dir .. ":" .. vim.env.PATH
  end

  -- Let pyright know which Python interpreter to use
  local clients = vim.lsp.get_clients({ name = "pyright" })
  for _, client in ipairs(clients) do
    client.config.settings = client.config.settings or {}
    client.config.settings.python = client.config.settings.python or {}
    client.config.settings.python.pythonPath = python_path
    client.rpc.notify("workspace/didChangeConfiguration", {
      settings = client.config.settings,
    })
  end
end

return M
