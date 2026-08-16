-- Auto-close/rename HTML tags (was configured via the legacy
-- nvim-treesitter `autotag` module option, which is deprecated upstream)
return {
	"windwp/nvim-ts-autotag",
	event = { "BufReadPre", "BufNewFile" },
	opts = {},
}
