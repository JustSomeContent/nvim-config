-- Auto Session takes advantage of Neovim's existing session management
-- capabilities to provide seamless automatic session management.
return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			-- bare `nvim` in a project dir saves on exit and restores on open;
			-- `nvim <file>` skips restore so direct edits stay untouched
			auto_save = true,
			auto_restore = true,
			suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
