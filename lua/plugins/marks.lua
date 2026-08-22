-- Vim marks are invisible by default: you set `ma`, forget it exists, and
-- `'a` later lands you somewhere surprising. marks.nvim puts every mark in
-- the sign column, adds `m`/`dm` prefixes to set/toggle/delete/navigate
-- them, and layers on numbered bookmark groups (m0-m9) with optional
-- virtual-text annotations. It only manages Vim's own marks — harpoon
-- stays the file-level jump list.
--
-- Persistence is Vim's (shada: lowercase marks per file, uppercase marks
-- global). If cross-session *annotated* bookmarks across large projects
-- become the real need, the upgrade path is LintaoAmons/bookmarks.nvim
-- (sqlite-backed, named lists, per-project) — replace this spec rather
-- than stacking the two.
--
-- Mappings (every one carries a "marks: …" desc, so which-key lists them
-- when you pause on `m` / `dm`):
--   mx / dmx      set / delete mark x           m, / m;    set next free mark / toggle mark on this line
--   m] / m[       next / previous mark          m:         preview a mark (<CR> previews the next one)
--   dm-           delete marks on this line     dm<space>  delete all marks in the buffer
--   m0-9 / dm0-9  set / clear bookmark group N  m} / m{    next / prev bookmark of the same group
--   dm=           delete bookmark under cursor  m=         annotate bookmark under cursor (not a default; added here)
-- Commands: :MarksListBuf / :MarksListAll / :BookmarksListAll (location list),
--           :MarksQFListAll / :BookmarksQFListAll (quickfix), :MarksToggleSigns.
-- Pickers: <leader>sm (telescope marks, see telescope.lua).
return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		default_mappings = true,
		mappings = {
			annotate = "m=", -- pairs with dm= (delete the bookmark under the cursor)
		},
		-- keep the sign column quiet in plugin UIs and terminals (the claude
		-- pane included); mappings still work everywhere
		excluded_buftypes = { "nofile", "prompt", "terminal", "quickfix" },
		excluded_filetypes = { "NvimTree", "lazy", "mason", "harpoon", "undotree", "diff", "aerial" },
	},
}
