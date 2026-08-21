-- Maximizer zooms the current split to the full window and restores the
-- previous layout on the next toggle. Lives under <leader>w (window) next to
-- the split/close maps in lua/keymaps.lua; works on any pane, including the
-- Claude Code split (leave terminal mode with <C-\><C-n> first).
return {
	"szw/vim-maximizer",
	keys = {
		{ "<leader>wm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/restore current window" },
	},
}
