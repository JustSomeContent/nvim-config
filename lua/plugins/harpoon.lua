-- Harpoon is incredibly helpful with have a file swatch to
-- quickly and painlessly access. Definitely makes file navigation
-- much simpler.
return {
	"ThePrimeagen/harpoon",
	-- master (v1) is unmaintained; harpoon2 is the supported rewrite.
	-- Marks live in harpoon2's own store, so v1 marks don't carry over.
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>mf", function()
			harpoon:list():add()
		end, { desc = "Mark file with harpoon" })
		keymap.set("n", "]h", function()
			harpoon:list():next()
		end, { desc = "Go to next harpoon mark" })
		keymap.set("n", "[h", function()
			harpoon:list():prev()
		end, { desc = "Go to previous harpoon mark" })
		keymap.set("n", "<leader>fm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "view file menu of harpoon marks" })
		for i = 1, 5 do
			keymap.set("n", ("<leader>%d"):format(i), function()
				harpoon:list():select(i)
			end, { desc = ("Navigate to Harpoon File %d"):format(i) })
		end
	end,
}
