-- Distraction-free editing: centers the buffer in a padded floating window
-- and hides surrounding UI until toggled off
return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle zen mode" },
	},
	opts = {
		window = {
			width = 120,
			options = {
				number = true,
				relativenumber = true,
			},
		},
	},
}
