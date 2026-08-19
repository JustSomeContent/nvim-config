return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	-- group labels for the leader prefixes (v3 spec format); individual
	-- mappings keep their desc at the definition site
	opts = {
		spec = {
			{ "<leader>s", group = "Search" },
			{ "<leader>w", group = "Window / Session" },
			{ "<leader>t", group = "Tabs / Terminal" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>f", group = "Find / Files" },
			{ "<leader>g", group = "Git / Gradle" },
			{ "<leader>c", group = "Code" },
			{ "<leader>r", group = "Run / Rename" },
			{ "<leader>n", group = "Swap with next" },
			{ "<leader>p", group = "Swap with previous" },
			{ "<leader>m", group = "Mark / Make" },
			{ "<leader>j", group = "Jump" },
			{ "<leader>a", group = "AI / Claude" },
		},
	},
}
