vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf" },
  callback = function()
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and "bigfile"
            or nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("bigfile", { clear = true }),
  pattern = "bigfile",
  callback = function(ev)
    vim.b.minianimate_disable = true

    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
    end)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    desc = 'Attach keymaps for quickfix list',
    callback = function()
        vim.keymap.set('n', 'dd', function()
            local qf_list = vim.fn.getqflist()

            local current_line_number = vim.fn.line('.')

            if qf_list[current_line_number] then
                table.remove(qf_list, current_line_number)

                vim.fn.setqflist(qf_list, 'r')

                local new_line_number = math.min(current_line_number, #qf_list)
                vim.fn.cursor(new_line_number, 1)
            end
        end, {
            buffer = true,
            noremap = true,
            silent = true,
            desc = 'Remove quickfix item under cursor',
        })
    end
})
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })
