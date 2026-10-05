return {
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",

          indicator = {
            icon = "▎",
            style = "icon",
          },

          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",

          max_name_length = 18,
          max_prefix_length = 15,
          truncate_names = true,

          tab_size = 18,

          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,

          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "center",
            },
          },

          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,

          persist_buffer_sort = true,
          separator_style = "thin",
          always_show_bufferline = true,

          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    event = { "BufReadPost", "BufNewFile" },

    opts = {
      signs = true,
      sign_priority = 8,

      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },

        TODO = {
          icon = " ",
          color = "info",
        },

        HACK = {
          icon = " ",
          color = "warning",
        },

        WARN = {
          icon = " ",
          color = "warning",
          alt = { "WARNING", "XXX" },
        },

        PERF = {
          icon = " ",
          alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
        },

        NOTE = {
          icon = " ",
          color = "hint",
          alt = { "INFO" },
        },

        TEST = {
          icon = "⏲ ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
      },

      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,

        before = "",
        keyword = "wide",
        after = "fg",

        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,

        max_line_len = 400,
        exclude = {},
      },

      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },

        pattern = [[\b(KEYWORDS):]],
      },
    },

    config = function(_, opts)
      require("todo-comments").setup(opts)

      -- Jump to next todo comment
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      -- Jump to previous todo comment
      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      -- Jump only between ERROR/WARNING comments
      vim.keymap.set("n", "]e", function()
        require("todo-comments").jump_next({
          keywords = { "ERROR", "WARNING", "WARN" },
        })
      end, { desc = "Next error/warning todo comment" })

      vim.keymap.set("n", "[e", function()
        require("todo-comments").jump_prev({
          keywords = { "ERROR", "WARNING", "WARN" },
        })
      end, { desc = "Previous error/warning todo comment" })

      -- fzf-lua integration (telescope is not installed)
      vim.keymap.set("n", "<leader>st", "<cmd>TodoFzfLua<cr>", {
        desc = "Search todo comments",
      })

      -- Quickfix list
      vim.keymap.set("n", "<leader>xt", "<cmd>TodoQuickFix<cr>", {
        desc = "Todo QuickFix",
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    keys = {
      {
        "<C-b>",
        "<cmd>Neotree toggle<CR>",
        desc = "Toggle Neo-tree",
      },
    },
    opts = {
      git_status = {
        symbols = {
          -- Change type
          added = "", -- or "✚"
          modified = "", -- or ""
          deleted = "✖", -- this can only be used in the git_status source
          renamed = "󰁕", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    }
  },
}
