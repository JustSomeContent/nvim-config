-- Formatting via conform.nvim: format-on-save only for filetypes with an
-- explicit formatter below — no LSP fallback on save, so JVM buffers are
-- never reformatted by surprise
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- the map lives here (not in config) so it also lazy-loads conform:
	-- with only the BufWritePre trigger it didn't exist until the first save
	keys = {
		{
			"<leader>mp",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "Format file ([M]ake [P]retty) or range (in visual mode)",
		},
	},
	config = function()
		local conform = require("conform")

		local formatters_by_ft = {
			elixir = { "mix" },
			heex = { "mix" },
			eex = { "mix" },
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			graphql = { "prettierd", "prettier", stop_after_first = true },
			-- ruff replaces isort+black: conform's ruff formatters prefer
			-- .venv/bin/ruff over the mason install, so project pins win
			python = { "ruff_organize_imports", "ruff_format" },
		}

		conform.setup({
			formatters_by_ft = formatters_by_ft,
			format_on_save = function(bufnr)
				if formatters_by_ft[vim.bo[bufnr].filetype] then
					return { timeout_ms = 2000, lsp_format = "never" }
				end
			end,
		})
	end,
}
