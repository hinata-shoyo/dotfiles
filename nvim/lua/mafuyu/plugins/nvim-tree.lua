return {
	"nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
    vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true

		require("nvim-tree").setup({
		  sort = {
		    sorter = "case_sensitive",
		  },
		  view = {
        side = "right",
		    width = 30,
		  },
		  --[[renderer = {
		    group_empty = true,
		  },]]--
		  filters = {
		    dotfiles = true,
		  },
		  renderer = {
        group_empty = true,
		    icons = {
		      show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = true,
		      },
		      glyphs = {
			folder = {
			  arrow_closed = "⏵",
			  arrow_open = "⏷",
			},
			git = {
			  unstaged = "✗",
			  staged = "✓",
			  unmerged = "⌥",
			  renamed = "➜",
			  untracked = "★",
			  deleted = "⊖",
			  ignored = "◌",
			},
		      },
		    },
		  },
		})
	end
}
