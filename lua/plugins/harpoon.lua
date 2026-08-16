-- Harpoon is incredibly helpful with have a file swatch to
-- quickly and painlessly access. Definitely makes file navigation
-- much simpler.
return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set(
			"n",
			"<leader>mf",
			"<cmd>lua require('harpoon.mark').add_file()<cr>",
			{ desc = "Mark file with harpoon" }
		)
		keymap.set(
			"n",
			"]h",
			"<cmd>lua require('harpoon.ui').nav_next()<cr>",
			{ desc = "Go to next harpoon mark" }
		)
		keymap.set(
			"n",
			"[h",
			"<cmd>lua require('harpoon.ui').nav_prev()<cr>",
			{ desc = "Go to previous harpoon mark" }
		)
		keymap.set(
			"n",
			"<leader>fm",
			"<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
			{ desc = "view file menu of harpoon marks" }
		)
		for i = 1, 5 do
			keymap.set(
				"n",
				("<leader>%d"):format(i),
				("<cmd>lua require('harpoon.ui').nav_file(%d)<cr>"):format(i),
				{ desc = ("Navigate to Harpoon File %d"):format(i) }
			)
		end
	end,
}
