-- Flashes a beacon over the cursor on big jumps and window switches.
-- Note: this is beacon.nvim v2 (Lua) — the old vim.g.beacon_* variables are ignored;
-- everything goes through setup()
return {
	"danilamihailov/beacon.nvim",
	config = function()
		local beacon_opts = {
			min_jump = 5, -- reserve the flash for real jumps; smear-cursor covers small motions
			width = 80, -- much wider flash than the default 40
			winblend = 10, -- nearly opaque at the start so the flash really pops
			highlight = { bg = "#ff9e64", ctermbg = 208 }, -- tokyonight orange instead of white
		}

		-- setup plus a short cooldown on the flash: one jump can trigger it through
		-- several paths at once (explicit map + CursorMoved + WinEnter), which
		-- stacked into a visible multi-flash
		local function setup_beacon()
			local beacon = require("beacon")
			beacon.setup(beacon_opts)
			local flash = beacon.highlight_cursor
			local last = 0
			beacon.highlight_cursor = function()
				local now = vim.uv.now()
				if now - last < 250 then
					return
				end
				last = now
				flash()
			end
		end

		setup_beacon()

		-- beacon caches a scratch buffer at module load; session restores wipe it
		-- and every flash afterwards errors. Reload the module to recreate it
		-- (setup clears and rebuilds its augroup, so re-running is safe)
		vim.api.nvim_create_autocmd("SessionLoadPost", {
			group = vim.api.nvim_create_augroup("BeaconSessionFix", { clear = true }),
			callback = function()
				-- flashes already queued during session sourcing would hit the dead
				-- buffer: disable synchronously so they no-op, then reload fresh
				require("beacon").config.enabled = false
				vim.schedule(function()
					package.loaded.beacon = nil
					setup_beacon()
				end)
			end,
		})

		-- flash when cycling search results, even for short jumps
		-- (small motions get fluid feedback from smear-cursor instead)
		for _, key in ipairs({ "n", "N", "*", "#" }) do
			vim.keymap.set(
				"n",
				key,
				key .. "<cmd>lua require('beacon').highlight_cursor()<CR>",
				{ silent = true, desc = ("Motion %s with beacon flash"):format(key) }
			)
		end

		-- only highlight the cursorline in the focused window
		local group = vim.api.nvim_create_augroup("MyCursorLineGroup", { clear = true })
		vim.api.nvim_create_autocmd("WinEnter", {
			group = group,
			callback = function()
				vim.opt_local.cursorline = true
			end,
		})
		vim.api.nvim_create_autocmd("WinLeave", {
			group = group,
			callback = function()
				vim.opt_local.cursorline = false
			end,
		})
	end,
}
