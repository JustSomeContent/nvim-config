return {
	-- master branch: the 0.1.x line is frozen and still calls the removed
	-- nvim-treesitter master API in its previewers
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		-- open file pickers via :tab drop — jumps to the tab already showing the
		-- file, otherwise opens it in a new tab (reusing the current one if empty)
		local tab_drop_mappings = {
			i = { ["<CR>"] = actions.select_tab_drop },
			n = { ["<CR>"] = actions.select_tab_drop },
		}

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = { mappings = tab_drop_mappings },
				oldfiles = { mappings = tab_drop_mappings },
				git_files = { mappings = tab_drop_mappings },
				-- same delete keys as the buffers picker (<M-d> insert / dd normal)
				marks = {
					mappings = {
						i = { ["<M-d>"] = actions.delete_mark },
						n = { ["dd"] = actions.delete_mark },
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for brevity

		keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
		keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
		keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		-- marks / jumps / registers: browse with preview; marks.nvim handles
		-- in-buffer signs, this is the cross-buffer list (delete with <M-d>/dd)
		keymap.set("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks (<M-d>/dd deletes)" })
		keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "[S]earch [J]umplist" })
		keymap.set("n", "<leader>sr", builtin.registers, { desc = "[S]earch [R]egisters (<CR> pastes, <C-e> edits)" })
		keymap.set("n", "<leader>tkm", ":Telescope keymaps<CR>", { desc = "[T]elescope keymaps" })

		keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })
	end,
}
