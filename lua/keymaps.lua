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
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<C-s>", ":w<CR>", opts)

-- Insert mode mappings
map("i", "jk", "<Esc>", opts)

-- Toggle search highlighting (nothing else may start with <leader>h,
-- or this map waits on timeoutlen before firing)
map("n", "<leader>h", ":nohlsearch<CR>", optsDes("Clear search highlighting"))

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", optsDes("Increment number"))
map("n", "<leader>-", "<C-x>", optsDes("Decrement number"))

-- Navigate Splits
vim.keymap.set("n", "<C-h>", "<C-w>h", optsDes("Navigate to left split"))
vim.keymap.set("n", "<C-l>", "<C-w>l", optsDes("Navigate to right split"))
vim.keymap.set("n", "<C-j>", "<C-w>j", optsDes("Navigate to lower split"))
vim.keymap.set("n", "<C-k>", "<C-w>k", optsDes("Navigate to upper split"))

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
