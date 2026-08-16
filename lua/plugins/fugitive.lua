return {
	"tpope/vim-fugitive",
	config = function()
		local keymap = vim.keymap
		keymap.set("n", "<leader>gs", vim.cmd.G, { desc = "Opens Fugitive [G]it" })
	end,
}
