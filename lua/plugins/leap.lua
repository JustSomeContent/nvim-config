-- leap.nvim is lightspeed's successor by the same author (lightspeed is
-- frozen); keeps the s/S two-character motions
return {
	"ggandor/leap.nvim",
	config = function()
		-- mapped by hand instead of set_default_mappings(): S stays unmapped
		-- in visual mode so nvim-surround's surround-selection keeps working
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward (2-char motion)" })
		vim.keymap.set({ "n", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward (2-char motion)" })
	end,
}
