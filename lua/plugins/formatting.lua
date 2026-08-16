-- Formatting via conform.nvim: format-on-save only for filetypes with an
-- explicit formatter below — no LSP fallback on save, so JVM buffers are
-- never reformatted by surprise
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
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
			python = { "isort", "black" },
		}

		conform.setup({
			formatters_by_ft = formatters_by_ft,
			format_on_save = function(bufnr)
				if formatters_by_ft[vim.bo[bufnr].filetype] then
					return { timeout_ms = 2000, lsp_format = "never" }
				end
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({ async = true, lsp_format = "fallback" })
		end, { desc = "Format file ([M]ake [P]retty) or range (in visual mode)" })
	end,
}
