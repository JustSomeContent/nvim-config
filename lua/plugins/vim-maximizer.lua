-- Maximizer lets you maximize split windows and
-- restore them automatically. It is very useful
-- if you like to have many split windows per tab.
return {
	"szw/vim-maximizer",
	keys = {
		{ "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
	},
}
