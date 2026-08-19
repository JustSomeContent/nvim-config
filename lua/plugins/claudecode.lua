-- Claude Code IDE integration: speaks the same WebSocket protocol as the
-- official VS Code extension against the locally installed `claude` CLI
-- (existing subscription auth — no API key). The plugin only runs the
-- in-editor server (selection tracking, context, diffs); the terminal stays
-- with toggleterm — <leader>ac toggles a dedicated float whose environment
-- pins CLAUDE_CODE_SSE_PORT to this instance's server, so claude connects
-- to *this* nvim even when other IDEs (VS Code windows, other nvims) have
-- live ~/.claude/ide/ lock files. `claude --ide` can't do that: it only
-- auto-connects when exactly one IDE lock file exists.
local claude_term

return {
	"coder/claudecode.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	-- load at startup (VeryLazy) so the server + lock file always exist:
	-- a claude session launched from any terminal can then /ide in
	event = "VeryLazy",
	opts = {
		terminal = {
			provider = "none", -- toggleterm owns the terminal; plugin is server-only
		},
	},
	keys = {
		{
			"<leader>ac",
			function()
				if not claude_term then
					local port = require("claudecode").state.port
					if not port then
						vim.notify("claudecode server is not running (:ClaudeCodeStatus)", vim.log.levels.ERROR)
						return
					end
					claude_term = require("toggleterm.terminal").Terminal:new({
						cmd = "claude",
						direction = "float",
						hidden = true, -- keeps it out of the <C-\> rotation
						-- same env the plugin's own providers set: makes the CLI
						-- attach to this exact server instead of scanning lock files
						env = {
							ENABLE_IDE_INTEGRATION = "true",
							FORCE_CODE_TERMINAL = "true",
							CLAUDE_CODE_SSE_PORT = tostring(port),
						},
					})
				end
				claude_term:toggle()
			end,
			desc = "Toggle Claude Code (floating)",
		},
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude context" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
		{ "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to Claude context", ft = { "NvimTree" } },
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
	},
}
