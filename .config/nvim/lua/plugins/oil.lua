return {
{
  "stevearc/oil.nvim",
  lazy = true,
  keys = {
    {
      "-",
      function()
        require("oil").toggle_float()
      end,
      desc = "Toggle Oil Float",
    },
  },
  opts = {
    columns = { "icon" },
    keymaps = {
      ["C-h"] = false,
      ["M-h"] = "actions.select_split",
    },
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 60,
      max_height = 16,
      border = "rounded",
      win_options = {
        winblend = 0, -- keep it fully opaque
      },
      get_win_title = nil,
      preview_split = "auto",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Dark theme highlights
    vim.cmd([[
      highlight OilNormal guibg=#000000 guifg=#c1c1c1
      highlight OilNormalNC guibg=#000000 guifg=#888888
      highlight OilDir guifg=#486e6f gui=bold
      highlight OilFile guifg=#c1c1c1
      highlight OilGitAdded guifg=#dd9999
      highlight OilGitModified guifg=#a06666
      highlight OilGitDeleted guifg=#888888
      highlight OilBorder guifg=#486e6f guibg=#000000
      highlight OilPreviewNormal guibg=#000000 guifg=#c1c1c1
      highlight OilPreviewBorder guifg=#486e6f guibg=#000000
    ]])
  end,
},

	{
		"ibhagwan/fzf-lua",
		lazy = true,
		cmd = "FzfLua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			keymap = {
				fzf = {
					["tab"] = "down",
					["shift-tab"] = "up",
					["ctrl-q"] = "select-all+accept",
				},
			},
			winopts = {
				height = 0.95,
				width = 0.95,
				preview = {
					layout = "horizontal",
					flip_columns = 0.65,
				},
				border = "rounded",
			},
			fzf_opts = {
				["--prompt"] = "   ",
				["--pointer"] = "󱞩 ",
			},
      files = {
        -- `fd` is not installed, so fzf-lua falls back to `rg --files`;
        -- the ignores have to live in rg_opts to take effect.
        rg_opts = "--color=never --files --hidden --follow "
          .. "-g '!.git' -g '!node_modules' -g '!.next' "
          .. "-g '!dist' -g '!venv' -g '!.vite'",
        fd_opts = "--color=never --type f --hidden --follow "
          .. "--exclude .git --exclude node_modules --exclude .next "
          .. "--exclude dist --exclude venv --exclude .vite",
      },
      grep = {
        -- Must be a single-line string ending in `-e`: fzf-lua does
        -- `string.format("rg %s", rg_opts)` and appends the query after it.
        rg_opts = "--column --line-number --no-heading --color=always "
          .. "--smart-case --max-columns=4096 --hidden "
          .. "-g '!.git' -g '!node_modules' -g '!.next' "
          .. "-g '!dist' -g '!venv' -g '!.vite' -e",
      },
      file_ignore_patterns = {
        "%.svg", "%.class", "%.png", "%.jpg",
      },
		},
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Files" },
			{ "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics Document" },
			{
				"<leader>ca",
				function()
					require("fzf-lua").lsp_code_actions({ silent = true })
				end,
				desc = "Code Actions",
			},
			{ "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Text" },
			{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
			{ "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
			{ "<leader>fC", "<cmd>FzfLua colorschemes<CR>", desc = "Colorscheme" },
			{ "<leader>gr", "<cmd>FzfLua lsp_references<CR>", desc = "Go to references" },
			{ "<leader>fq", "<cmd>FzfLua quickfix<CR>", desc = "Open Quickfix list" },
			{ "<leader>rr", "<cmd>FzfLua registers<CR>", desc = "Find registers list" },
		},
	},
}
