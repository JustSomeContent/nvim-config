return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function(args)
				-- buffer-local: a global map here would replace conform's <leader>mp
				-- (format) everywhere as soon as any markdown buffer opened
				vim.keymap.set(
					"n",
					"<leader>mp",
					":MarkdownPreviewToggle<CR>",
					{ buffer = args.buf, desc = "Toggle Markdown Preview" }
				)
			end,
		})
	end,
}
