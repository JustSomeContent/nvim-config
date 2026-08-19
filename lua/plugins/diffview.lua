-- Whole-branch diffs, per-file history, and a 3-way merge-conflict view —
-- the space between gitsigns' hunks and fugitive's status. For reviewing a
-- branch, run e.g. :DiffviewOpen main...HEAD
return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff working tree against HEAD" },
		{ "<leader>gF", "<cmd>DiffviewFileHistory %<CR>", desc = "History of current file" },
		-- gx to close, matching the tx/wx close convention
		{ "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
	},
	opts = {},
}
