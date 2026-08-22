-- Maximizer zooms the current split to the full window and restores the
-- previous layout on the next toggle. Lives under <leader>w (window) next to
-- the split/close maps in lua/keymaps.lua; works on any pane, including the
-- Claude Code split (leave terminal mode with <C-\><C-n> first).
--
-- Zoom follows tmux semantics: moving to another real window restores the
-- layout first. Without that, <C-h/j/k/l> out of a zoomed pane lands in a
-- 1-column sliver and looks like navigation is broken. Floats (telescope,
-- pickers) and returning to the zoomed window itself don't un-zoom.
return {
	"szw/vim-maximizer",
	keys = {
		{
			"<leader>wm",
			function()
				vim.cmd("MaximizerToggle")
				-- remember which window is zoomed; the plugin only keeps sizes
				vim.t.maximizer_win = vim.t.maximizer_sizes and vim.api.nvim_get_current_win() or nil
			end,
			desc = "Maximize/restore current window",
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("WinEnter", {
			group = vim.api.nvim_create_augroup("MaximizerRestoreOnMove", { clear = true }),
			callback = function()
				local win = vim.api.nvim_get_current_win()
				if
					vim.t.maximizer_sizes
					and win ~= vim.t.maximizer_win
					and vim.api.nvim_win_get_config(win).relative == ""
				then
					vim.cmd("MaximizerToggle!") -- bang = force restore
					vim.t.maximizer_win = nil
				end
			end,
		})
	end,
}
