-- Provides an overview of project structure to quickly
-- see Structures, Traits, Functions, etc.
--
-- NOTE: requires external dependency of ctags:
-- https://github.com/universal-ctags/ctags
return {
	"preservim/tagbar",
	config = function()
		local keymap = vim.keymap
		local opts = function(desc)
			return { desc = desc }
		end

		keymap.set("n", "<leader>ps", "<cmd>TagbarToggle<CR>", opts("View the [P]roject [S]tructure"))
	end,
}
