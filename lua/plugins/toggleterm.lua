-- Popup terminal: <C-\> pops a floating terminal in and out from any mode;
-- <leader>ti does the same with an iex session (mix-aware)
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-\>]], -- works in normal, insert, and terminal mode
			shell = "/bin/zsh", -- login shell is homebrew bash; popup should be zsh
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})

		-- double-esc drops any toggleterm terminal into normal mode
		-- (single esc still reaches the shell/iex for their own uses)
		vim.api.nvim_create_autocmd("TermOpen", {
			group = vim.api.nvim_create_augroup("ToggleTermKeymaps", { clear = true }),
			pattern = "term://*toggleterm#*",
			callback = function(ev)
				vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = ev.buf, desc = "Terminal to normal mode" })
			end,
		})

		-- dedicated iex terminal, created on first use so the mix.exs lookup
		-- reflects where you're actually working
		local iex_term
		vim.keymap.set("n", "<leader>ti", function()
			if not iex_term then
				local start = vim.api.nvim_buf_get_name(0) ~= "" and vim.fn.expand("%:p:h") or vim.uv.cwd()
				local mix = vim.fs.find("mix.exs", { upward = true, path = start })[1]
				iex_term = require("toggleterm.terminal").Terminal:new({
					cmd = mix and "iex -S mix" or "iex",
					dir = mix and vim.fs.dirname(mix) or nil,
					direction = "float",
					hidden = true, -- keeps it out of the <C-\> rotation
				})
			end
			iex_term:toggle()
		end, { desc = "Toggle iex terminal (mix-aware)" })
	end,
}
