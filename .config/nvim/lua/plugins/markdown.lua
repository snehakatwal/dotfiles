local function glow_preview()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Save the file first, glow reads it from disk", vim.log.levels.WARN)
    return
  end
  vim.cmd("silent update")
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " glow: " .. vim.fn.fnamemodify(file, ":t") .. " ",
    title_pos = "center",
  })

  vim.fn.jobstart({ "glow", "-s", "dark", "-w", tostring(width - 4), file }, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_cursor(win, { 1, 0 })
        end
      end)
    end,
  })
  vim.bo[buf].bufhidden = "wipe"
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true })
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", ft = "markdown", desc = "Markdown: toggle render" },
      { "<leader>mp", "<cmd>RenderMarkdown preview<CR>", ft = "markdown", desc = "Markdown:side preview" },
      { "<leader>mg", glow_preview, ft = "markdown", desc = "Markdown: glow preview" },
    },
  },
}
