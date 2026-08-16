return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = "VeryLazy",
	init = function()
		-- keymaps below are global; stop built-in ftplugins (python, etc.) from
		-- shadowing ]m/[m and friends with their own buffer-local maps.
		-- Tradeoff: this disables ALL stock ftplugin maps, not just these.
		vim.g.no_plugin_maps = true
	end,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
			},
			move = {
				-- whether to set jumps in the jumplist
				set_jumps = true,
			},
		})

		local ts_select = require("nvim-treesitter-textobjects.select")
		-- You can use the capture groups defined in textobjects.scm
		local select_maps = {
			["a="] = { "@assignment.outer", "Select outer part of an assignment" },
			["i="] = { "@assignment.inner", "Select inner part of an assignment" },
			["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
			["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },

			-- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
			["a:"] = { "@property.outer", "Select outer part of an object property" },
			["i:"] = { "@property.inner", "Select inner part of an object property" },
			["l:"] = { "@property.lhs", "Select left part of an object property" },
			["r:"] = { "@property.rhs", "Select right part of an object property" },

			["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
			["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },

			["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
			["ii"] = { "@conditional.inner", "Select inner part of a conditional" },

			["al"] = { "@loop.outer", "Select outer part of a loop" },
			["il"] = { "@loop.inner", "Select inner part of a loop" },

			["af"] = { "@call.outer", "Select outer part of a function call" },
			["if"] = { "@call.inner", "Select inner part of a function call" },

			["am"] = { "@function.outer", "Select outer part of a method/function definition" },
			["im"] = { "@function.inner", "Select inner part of a method/function definition" },

			["ac"] = { "@class.outer", "Select outer part of a class" },
			["ic"] = { "@class.inner", "Select inner part of a class" },
		}
		for lhs, m in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				ts_select.select_textobject(m[1], "textobjects")
			end, { desc = m[2] })
		end

		local ts_swap = require("nvim-treesitter-textobjects.swap")
		local swap_maps = {
			swap_next = {
				["<leader>na"] = { "@parameter.inner", "Swap parameter/argument with next" },
				["<leader>n:"] = { "@property.outer", "Swap object property with next" },
				["<leader>nm"] = { "@function.outer", "Swap function with next" },
			},
			swap_previous = {
				["<leader>pa"] = { "@parameter.inner", "Swap parameter/argument with prev" },
				["<leader>p:"] = { "@property.outer", "Swap object property with prev" },
				["<leader>pm"] = { "@function.outer", "Swap function with previous" },
			},
		}
		for method, maps in pairs(swap_maps) do
			for lhs, m in pairs(maps) do
				vim.keymap.set("n", lhs, function()
					ts_swap[method](m[1])
				end, { desc = m[2] })
			end
		end

		local ts_move = require("nvim-treesitter-textobjects.move")
		-- Third entry is the query group: queries/<lang>/<group>.scm on the runtimepath
		local move_maps = {
			goto_next_start = {
				["]f"] = { "@call.outer", "textobjects", "Next function call start" },
				["]m"] = { "@function.outer", "textobjects", "Next method/function def start" },
				["]c"] = { "@class.outer", "textobjects", "Next class start" },
				["]i"] = { "@conditional.outer", "textobjects", "Next conditional start" },
				["]l"] = { "@loop.outer", "textobjects", "Next loop start" },
				["]s"] = { "@local.scope", "locals", "Next scope" }, -- capture renamed on main (was @scope)
				["]z"] = { "@fold", "folds", "Next fold" },
			},
			goto_next_end = {
				["]F"] = { "@call.outer", "textobjects", "Next function call end" },
				["]M"] = { "@function.outer", "textobjects", "Next method/function def end" },
				["]C"] = { "@class.outer", "textobjects", "Next class end" },
				["]I"] = { "@conditional.outer", "textobjects", "Next conditional end" },
				["]L"] = { "@loop.outer", "textobjects", "Next loop end" },
			},
			goto_previous_start = {
				["[f"] = { "@call.outer", "textobjects", "Prev function call start" },
				["[m"] = { "@function.outer", "textobjects", "Prev method/function def start" },
				["[c"] = { "@class.outer", "textobjects", "Prev class start" },
				["[i"] = { "@conditional.outer", "textobjects", "Prev conditional start" },
				["[l"] = { "@loop.outer", "textobjects", "Prev loop start" },
			},
			goto_previous_end = {
				["[F"] = { "@call.outer", "textobjects", "Prev function call end" },
				["[M"] = { "@function.outer", "textobjects", "Prev method/function def end" },
				["[C"] = { "@class.outer", "textobjects", "Prev class end" },
				["[I"] = { "@conditional.outer", "textobjects", "Prev conditional end" },
				["[L"] = { "@loop.outer", "textobjects", "Prev loop end" },
			},
		}
		for method, maps in pairs(move_maps) do
			for lhs, m in pairs(maps) do
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					ts_move[method](m[1], m[2])
				end, { desc = m[3] })
			end
		end

		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		-- vim way: ; goes to the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		-- (the main branch exposes these as expr functions)
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
