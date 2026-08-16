-- ~/.config/nvim/init.lua

-- Load settings
require("settings")

-- Load keymaps
require("keymaps")

-- Load Autogroups
require("autogroups")

-- Bootstrap lazy.nvim, handle installation if not present.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable", -- latest stable release
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins")

-- Load LSP
-- require("lsp")
