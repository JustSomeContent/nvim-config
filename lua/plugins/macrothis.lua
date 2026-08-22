-- nvim-recorder (nvim-recorder.lua) owns recording and playback: slots
-- a/b/c, q/Q, <C-q> to switch slot, cq to edit, yq to yank. What it lacks
-- is a *library* — slots survive restarts via shada, but `"ay` clobbers
-- them and nothing has a name. macrothis fills that: save any register's
-- macro under a name to stdpath("data")/macrothis.json, then load / run /
-- edit / rename / delete it later (or on another machine that syncs that
-- file). Its own prompts go through vim.ui.select/vim.ui.input (snacks);
-- :Telescope macrothis is the one-stop picker with in-picker actions:
--   <CR> load into a register   <C-r> run (takes a count)   <C-e> edit
--   <C-n> rename                <C-d> delete                <C-s> save
--   <C-q> run on quickfix files <C-x> edit a register       <C-c> copy printable
return {
	"desdic/macrothis.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {
		-- scratch register used when running/editing a saved macro — kept off
		-- recorder's a/b/c slots so playing from the library never clobbers one
		run_register = "z",
	},
	config = function(_, opts)
		require("macrothis").setup(opts)
		require("telescope").load_extension("macrothis")
	end,
	keys = {
		{ "<leader>qq", "<cmd>Telescope macrothis<cr>", desc = "Macro library (telescope)" },
		{
			"<leader>qs",
			function()
				require("macrothis").save()
			end,
			desc = "Save a register as a named macro",
		},
		{
			"<leader>ql",
			function()
				require("macrothis").load()
			end,
			desc = "Load a named macro into a register",
		},
		{
			"<leader>qr",
			function()
				require("macrothis").run()
			end,
			desc = "Run a named macro",
		},
		{
			"<leader>qe",
			function()
				require("macrothis").edit()
			end,
			desc = "Edit a named macro",
		},
		{
			"<leader>qn",
			function()
				require("macrothis").rename()
			end,
			desc = "Rename a named macro",
		},
		{
			"<leader>qd",
			function()
				require("macrothis").delete()
			end,
			desc = "Delete a named macro",
		},
		{
			"<leader>qQ",
			function()
				require("macrothis").quickfix()
			end,
			desc = "Run a named macro on every quickfix file",
		},
		{
			"<leader>qx",
			function()
				require("macrothis").register()
			end,
			desc = "Edit a register in place",
		},
		{
			"<leader>qy",
			function()
				require("macrothis").copy_macro_printable()
			end,
			desc = "Yank a named macro as printable text",
		},
		{
			"<leader>qY",
			function()
				require("macrothis").copy_register_printable()
			end,
			desc = "Yank a register as printable text",
		},
	},
}
