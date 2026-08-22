-- ~/.config/nvim/lua/keymaps.lua
--
-- testing some stuff

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local function optsDes(des)
	return { noremap = true, silent = true, desc = des }
end

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal mode mappings
map("n", "<leader>e", ":NvimTreeToggle<CR>", optsDes("Toggle file explorer"))
map("n", "<C-s>", ":w<CR>", optsDes("Save file"))

-- Insert mode mappings
map("i", "jk", "<Esc>", optsDes("Exit insert mode"))

-- Toggle search highlighting (nothing else may start with <leader>h,
-- or this map waits on timeoutlen before firing)
map("n", "<leader>h", ":nohlsearch<CR>", optsDes("Clear search highlighting"))

-- Increment/decrement numbers (normal: number under/after the cursor; visual:
-- the selection). Plain <C-a>/<C-x> read a dash before a number as a minus
-- sign, so "decrementing" 21 in 2026-08-21 or 3 in item-3 makes the visible
-- digits go UP. A dash glued to a word character is a hyphen: treat the number
-- as unsigned for that one operation; a free-standing dash (x = -3) stays a
-- sign, so real negatives and going below zero still work.
local function bump(key, desc)
	vim.keymap.set({ "n", "x" }, key == "\1" and "<leader>+" or "<leader>-", function()
		local line = vim.api.nvim_get_current_line()
		local s = vim.api.nvim_win_get_cursor(0)[2] + 1
		if not line:sub(s, s):match("%d") then
			s = line:find("%d", s) or s -- <C-a> acts on the next number to the right
		end
		while s > 1 and line:sub(s - 1, s - 1):match("%d") do
			s = s - 1
		end
		local prev = s > 1 and line:sub(s - 1, s - 1) or ""
		local prev2 = s > 2 and line:sub(s - 2, s - 2) or ""
		local hyphen = prev == "-" and prev2:match("[%w_]") ~= nil
		local saved = vim.bo.nrformats
		if hyphen then
			vim.opt_local.nrformats:append("unsigned")
		end
		vim.cmd.normal({ args = { vim.v.count1 .. key }, bang = true })
		vim.bo.nrformats = saved
	end, optsDes(desc))
end
bump("\1", "Increment number") -- \1 = <C-a>
bump("\24", "Decrement number") -- \24 = <C-x>

-- Navigate splits; with no window that way, hand the move to WezTerm so the
-- key flows on into the neighbouring WezTerm pane, tmux-style. This is the
-- other half of a handshake: ~/.wezterm.lua forwards CTRL+h/j/k/l to nvim
-- whenever nvim is the pane's foreground process (otherwise WezTerm would
-- swallow them for its own pane navigation and nvim never sees the key).
-- `wezterm` isn't on PATH; it sits next to $WEZTERM_EXECUTABLE (wezterm-gui).
local wezterm_direction = { h = "Left", j = "Down", k = "Up", l = "Right" }
local function wezterm_bin()
	local gui = vim.env.WEZTERM_EXECUTABLE
	local bin = gui and (vim.fn.fnamemodify(gui, ":h") .. "/wezterm") or "wezterm"
	return vim.fn.executable(bin) == 1 and bin or nil
end
local function nav(dir)
	return function()
		if vim.fn.winnr(dir) ~= vim.fn.winnr() then
			vim.cmd.wincmd(dir)
			return
		end
		local bin = vim.env.WEZTERM_PANE and wezterm_bin()
		if bin then
			vim.system({ bin, "cli", "activate-pane-direction", wezterm_direction[dir] })
		end
	end
end
vim.keymap.set("n", "<C-h>", nav("h"), optsDes("Navigate to left split (or WezTerm pane)"))
vim.keymap.set("n", "<C-l>", nav("l"), optsDes("Navigate to right split (or WezTerm pane)"))
vim.keymap.set("n", "<C-j>", nav("j"), optsDes("Navigate to lower split (or WezTerm pane)"))
vim.keymap.set("n", "<C-k>", nav("k"), optsDes("Navigate to upper split (or WezTerm pane)"))

-- ...and from inside a terminal (the Claude pane): move when a window exists
-- in that direction, otherwise hand the key to the program so <C-j> newline /
-- <C-l> redraw / <C-h> backspace still reach it (no WezTerm hand-off here —
-- the program needs those keys). Floating terminals (the toggleterm popup)
-- have no neighbours, so their keys always pass through.
local function term_nav(dir, key, desc)
	vim.keymap.set("t", key, function()
		local floating = vim.api.nvim_win_get_config(0).relative ~= ""
		if floating or vim.fn.winnr(dir) == vim.fn.winnr() then
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "n", false)
		else
			vim.cmd.wincmd(dir)
		end
	end, optsDes(desc))
end
term_nav("h", "<C-h>", "Navigate to left split (or send to terminal)")
term_nav("l", "<C-l>", "Navigate to right split (or send to terminal)")
term_nav("j", "<C-j>", "Navigate to lower split (or send to terminal)")
term_nav("k", "<C-k>", "Navigate to upper split (or send to terminal)")

-- Window management (<leader>w = window; <leader>s belongs to Telescope's search maps)
map("n", "<leader>wv", "<C-w>v", optsDes("Split window vertically"))
map("n", "<leader>wh", "<C-w>s", optsDes("Split window horizontally"))
map("n", "<leader>we", "<C-w>=", optsDes("Make splits equal size"))
map("n", "<leader>wx", "<cmd>close<CR>", optsDes("Close current split"))

-- File Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", optsDes("Open new tab"))
map("n", "<leader>tx", "<cmd>tabclose<CR>", optsDes("Close current tab"))
map("n", "<leader>tn", "<cmd>tabn<CR>", optsDes("Go to next tab"))
map("n", "<leader>tp", "<cmd>tabp<CR>", optsDes("Got to previous tab"))
map("n", "<leader>tf", "<cmd>tabnew %<CR>", optsDes("Open curren buffer in a new tab"))

-- Working directory (was <leader>hh, which harpoon shadowed)
map("n", "<leader>cd", "<cmd>cd %:h<CR>", optsDes("Set working dir to this file's dir"))

-- For my sanity
-- map("n", "x", "_x", optsDes("delete single char under the cursor without copying into register"))
-- map("n", "X", "_X", optsDes("delete single char before the cursour without copying into register"))
