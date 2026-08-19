-- Provides an overview of project structure to quickly
-- see Structures, Traits, Functions, etc.
-- Replaces tagbar: driven by the LSP/treesitter stack already running,
-- no external ctags install needed.
return {
	"stevearc/aerial.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		-- the bang keeps focus in the code window, like TagbarToggle did
		{ "<leader>ps", "<cmd>AerialToggle!<CR>", desc = "View the [P]roject [S]tructure" },
	},
	opts = {},
}
