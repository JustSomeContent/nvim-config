-- dressing.nvim is archived; its author points at snacks.nvim for the
-- vim.ui.input / vim.ui.select upgrades. Only those two modules are
-- enabled — telescope stays the picker for everything else.
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 900, -- before other plugins so early vim.ui calls are covered
	opts = {
		input = { enabled = true },
		picker = { enabled = true, ui_select = true },
	},
}
