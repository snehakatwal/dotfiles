return {
  -- Blink completion
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "saghen/blink.lib"
    },
    build = function()
      require("blink.cmp").build():pwait()
    end,
    event = "InsertEnter",
    opts = {
      appearance = {
        nerd_font_variant = "mono",
      },
      keymap = {
        preset = "enter",
        ["<Enter>"] = { "accept", "fallback" },
        ["<C-n>"] = { "select_next" },
        ["<C-p>"] = { "select_prev" },
      },
      cmdline = { enabled = false },
      completion = {
        menu = { border = "single" },
        documentation = {
          auto_show_delay_ms = 0,
          window = { border = "single" },
          auto_show = false,
        },
        trigger = {
          show_in_snippet = true,
          show_on_trigger_character = true,
        },
      },
      signature = {
        enabled = true,
        window = { border = "single" },
      },
      sources = {
        providers = { lsp = { async = true } },
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
