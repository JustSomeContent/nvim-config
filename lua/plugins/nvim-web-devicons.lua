-- A lua fork of vim-devicons. This plugin provides
-- the same icons as well as colors for each icon.
-- Light and dark color variants are provided.
return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		require("nvim-web-devicons").set_icon({
			gql = {
				icon = "",
				color = "#e535ab",
				cterm_color = "199",
				name = "GraphQL",
			},
		})
	end,
}
