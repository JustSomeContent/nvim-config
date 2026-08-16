-- Treesitter for syntax highlighting
vim.filetype.add({ extension = { gradle = "groovy" } })

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			-- parsers are compiled with the tree-sitter CLI (brew install tree-sitter-cli)
			-- and installed to stdpath("data") .. "/site"
			treesitter.setup({})

			-- ensure these language parsers are installed (async, no-op when already present)
			treesitter.install({
				"java",
				"kotlin",
				"groovy",
				"python",
				"rust",
				"go",
				"c",
				"cpp",
				"vue",
				"json",
				"terraform",
				"toml",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"erlang",
				"elixir",
				"heex", -- elixir injection queries reference heex/eex
				"eex",
			})

			-- on the main branch, highlighting and indentation are enabled per buffer
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(ev)
					-- skip filetypes without an installed parser
					if not pcall(vim.treesitter.start, ev.buf) then
						return
					end
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- incremental selection: the main branch dropped the module and 0.12 core
			-- has no equivalent, so this is a minimal local replacement
			local sel_stacks = {}

			local function select_range(node)
				local sr, sc, er, ec = node:range()
				if ec == 0 then
					-- an exclusive end column of 0 means "end of the previous line"
					er = er - 1
					ec = math.max(#vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1], 1)
				end
				if vim.fn.mode() ~= "n" then
					vim.cmd("normal! \27")
				end
				vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
			end

			vim.keymap.set({ "n", "x" }, "<C-space>", function()
				local buf = vim.api.nvim_get_current_buf()
				local stack = sel_stacks[buf]
				local node
				if vim.fn.mode() == "n" or not stack or #stack == 0 then
					node = vim.treesitter.get_node()
					stack = node and { node } or {}
				else
					node = stack[#stack]
					local parent = node:parent()
					-- skip ancestors with an identical range so each press visibly expands
					while parent and vim.deep_equal({ parent:range() }, { node:range() }) do
						node, parent = parent, parent:parent()
					end
					node = parent or node
					stack[#stack + 1] = node
				end
				sel_stacks[buf] = stack
				if node then
					select_range(node)
				end
			end, { desc = "Incremental selection (expand node)" })

			vim.keymap.set("x", "<bs>", function()
				local stack = sel_stacks[vim.api.nvim_get_current_buf()]
				if stack and #stack > 1 then
					table.remove(stack)
					select_range(stack[#stack])
				end
			end, { desc = "Incremental selection (shrink node)" })
		end,
	},
}
