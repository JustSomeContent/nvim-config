-- A fancy, configurable, notification manager for NeoVim
return {
	"rcarriga/nvim-notify",
	config = function()
		-- nothing routes through the plugin unless it replaces vim.notify
		vim.notify = require("notify")
	end,
}
