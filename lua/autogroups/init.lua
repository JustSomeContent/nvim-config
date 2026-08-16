-- autogroups/init.lua

-- For the sake of brevity
local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local opts = function(desc)
	return {
		noremap = true,
		silent = true,
		desc = desc,
	}
end

-- Yank Highlighting
nvim_create_autocmd("TextYankPost", {
	group = nvim_create_augroup("YankHighlight", { clear = true }),
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

nvim_create_autocmd({ "VimEnter", "BufReadPre" }, {
	group = nvim_create_augroup("LuafileAutoCmds", { clear = true }),
	pattern = { "*.lua" },
	desc = "Sets keybindings specific to Luafiles",
	callback = function()
		vim.api.nvim_set_keymap(
			"n",
			"<leader>rl",
			":!/Applications/love.app/Contents/MacOS/love .<CR>",
			opts("run Love Engine")
		)
	end,
})

-- Gradle Integration
nvim_create_autocmd({ "VimEnter", "BufReadPre" }, {
	group = nvim_create_augroup("GradleAutoCmds", { clear = true }),
	-- pattern = { "*.kt", "*.kts", "*.java", "*.gradle" },
	desc = "Sets keybindings for executing Gradle commands if working within a gradle project",
	callback = function()
		local is_gradle_project = function()
			for _, gradle_filename in ipairs({
				"build.gradle",
				"build.gradle.kts",
				"settings.gradle",
				"gradlew",
				"gradlew.bat",
			}) do
				if vim.fn.filereadable(gradle_filename) == 1 then
					return true
				end
			end
			return false
		end

		if is_gradle_project() then
			nvim_set_keymap("n", "<leader>gb", ":!gradle build<CR>", opts("build gradle project"))
			nvim_set_keymap("n", "<leader>gt", ":!gradle test<CR>", opts("test gradle project"))
			nvim_set_keymap("n", "<leader>r.", ":!gradle run<CR>", opts("run gradle project"))
		end
	end,
})

-- Kotlin Specific Integration
nvim_create_autocmd({ "BufReadPost", "BufWinEnter", "BufNewFile", "WinEnter" }, {
	group = nvim_create_augroup("KotlinAutoCmds", { clear = true }),
	pattern = { "*.kt", "*.kts", "*.java" },
	desc = "Sets keybindings specific to kotlin files",
	callback = function()
		local function is_in_test_path()
			local filepath = vim.fn.expand("%:p")
			return filepath:match("/test/")
		end

		if is_in_test_path() then
			-- Remove buffer-local keymap if it exists
			pcall(vim.api.nvim_buf_del_keymap, 0, "n", "<leader>jt")
		else
			local kotlin_util = require("autogroups.kotlin")
			vim.keymap.set("n", "<leader>jt", kotlin_util.create_or_open_testfile, {
				noremap = true,
				silent = true,
				desc = "Jumps to the test file for the project, or creates it and jumps to it.",
				buffer = true, -- Makes the keymap buffer-local
			})
		end
	end,
})
