local map = vim.api.nvim_set_keymap
local default_settings = function(desc)
	return { noremap = true, silent = true, desc = desc }
end

return {
	"vim-test/vim-test",
	config = function()
		-- Optional: Configure vim-test settings
		-- Set Busted as the Lua test runner
		vim.g["test#lua#runner"] = "busted"

		-- Define key mappings for test commands
		map("n", "<leader>t.", ":TestFile<CR>", default_settings("[T]est current file"))
		map("n", "<leader>t-", ":TestNearest<CR>", default_settings("[T]est Nearest test"))
		map("n", "<leader>ts", ":TestSuite<CR>", default_settings("[T]est [S]uite"))
		map("n", "<leader>tl", ":TestLast<CR>", default_settings("[T]est [L]ast run test"))
		map("n", "<leader>tv", ":TestVisit<CR>", default_settings("[T]est [V]isit"))
	end,
}
