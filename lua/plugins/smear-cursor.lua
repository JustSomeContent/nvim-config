-- Animates the cursor as a smooth smear between positions, so small motions
-- (word hops, short jumps) read as fluid movement instead of beacon flashes
return {
	"sphamba/smear-cursor.nvim",
	opts = {
		cursor_color = "#ff9e64", -- match the beacon orange
	},
}
