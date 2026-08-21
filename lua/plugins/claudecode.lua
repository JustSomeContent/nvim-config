-- Claude Code IDE integration: speaks the same WebSocket protocol as the
-- official VS Code extension against the locally installed `claude` CLI
-- (existing subscription auth — no API key). The plugin runs the in-editor
-- server (selection tracking, context, diffs) and, through its "native"
-- provider, the terminal: a full-height vertical split on the right whose
-- environment pins CLAUDE_CODE_SSE_PORT to this instance's server, so claude
-- attaches to *this* nvim even when other IDEs (VS Code windows, other
-- nvims) have live ~/.claude/ide/ lock files. `claude --ide` can't do that:
-- it only auto-connects when exactly one IDE lock file exists.
--
-- Why not a toggleterm terminal: toggleterm maps its open_mapping (<C-\>)
-- in terminal mode inside every buffer it owns, which swallows the first
-- key of <C-\><C-n> — the stock way back to Normal mode. The native
-- provider is a plain termopen buffer with no keymaps of its own, so
-- <C-\><C-n> leaves claude for nvim and <C-\> stays the toggleterm float's.
return {
	"coder/claudecode.nvim",
	-- load at startup (VeryLazy) so the server + lock file always exist:
	-- a claude session launched from any terminal can then /ide in
	event = "VeryLazy",
	opts = {
		terminal = {
			provider = "native", -- plain termopen split; sets no terminal-mode keymaps
			split_side = "right",
			split_width_percentage = 0.35, -- claude's TUI wants ~60+ cols; <leader>wm zooms it
			show_native_term_exit_tip = false, -- <C-\><C-n> is already muscle memory
		},
	},
	config = function(_, opts)
		require("claudecode").setup(opts)
		-- Hopping into the pane with <C-h/j/k/l> (or any window move) should
		-- leave you typing to claude, like <leader>af does: WinEnter on the
		-- plugin's own terminal buffer enters terminal mode
		vim.api.nvim_create_autocmd("WinEnter", {
			group = vim.api.nvim_create_augroup("ClaudeCodePaneInsert", { clear = true }),
			callback = function()
				if vim.api.nvim_get_current_buf() == require("claudecode.terminal").get_active_terminal_bufnr() then
					vim.cmd("startinsert")
				end
			end,
		})
	end,
	keys = {
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code (right split)" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code (hide if focused)" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Claude Code: resume a past session (picker)" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude Code: continue most recent session" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude context" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
		{ "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to Claude context", ft = { "NvimTree" } },
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
	},
}
