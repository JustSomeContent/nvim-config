-- LSP progress in the corner: jdtls and kotlin-lsp take a while to warm
-- up, and without this there's no signal that indexing is underway
return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {},
}
