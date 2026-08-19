return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		on_attach = function(bufnr)
			local gs = require("gitsigns")
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- in diff windows ]c/[c must stay the builtin change-jump
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next git hunk")
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Previous git hunk")

			-- stage_hunk on an already-staged hunk un-stages it
			map("n", "<leader>ghs", gs.stage_hunk, "Stage/unstage hunk")
			map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>ghs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Stage/unstage selected lines")
			map("v", "<leader>ghr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, "Reset selected lines")
			map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
			map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Git blame line")
			map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline git blame")
		end,
	},
}
