-- autogroups/elixir.lua
-- Elixir counterpart to autogroups/kotlin.lua, using the standard mirroring:
--   lib/manor/game.ex  <->  test/manor/game_test.exs

local function file_exists(filepath)
	return vim.fn.filereadable(filepath) == 1
end

local function get_test_file_path(current_file_path)
	local test_file_path = current_file_path:gsub("/lib/", "/test/", 1)
	return (test_file_path:gsub("%.ex$", "_test.exs"))
end

local function get_source_file_path(test_file_path)
	local source_file_path = test_file_path:gsub("/test/", "/lib/", 1)
	return (source_file_path:gsub("_test%.exs$", ".ex"))
end

-- Pull the module name out of the source buffer so the test template
-- matches whatever the file actually defines
local function get_module_name()
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 50, false)) do
		local module_name = line:match("^%s*defmodule%s+([%w%.]+)")
		if module_name then
			return module_name
		end
	end
	return "Module"
end

local function insert_test_template(module_name)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, {
		"defmodule " .. module_name .. "Test do",
		"  use ExUnit.Case, async: true",
		"",
		'  test "TODO" do',
		"    assert true == false",
		"  end",
		"end",
	})
end

-- Jump to a window already showing the file, open it in a vsplit otherwise
local function jump_or_vsplit(filepath)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)) == filepath then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
	vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))
end

local function create_or_open_testfile()
	local current_file_path = vim.fn.expand("%:p")
	if current_file_path == "" then
		return
	end

	local test_file_path = get_test_file_path(current_file_path)
	local module_name = get_module_name()

	if file_exists(test_file_path) then
		jump_or_vsplit(test_file_path)
	else
		vim.fn.mkdir(vim.fn.fnamemodify(test_file_path, ":h"), "p")
		jump_or_vsplit(test_file_path)
		insert_test_template(module_name)
	end
end

local function jump_to_source()
	local source_file_path = get_source_file_path(vim.fn.expand("%:p"))
	if file_exists(source_file_path) then
		jump_or_vsplit(source_file_path)
	else
		vim.notify("No source file found at " .. source_file_path, vim.log.levels.WARN)
	end
end

return {
	create_or_open_testfile = create_or_open_testfile,
	jump_to_source = jump_to_source,
}
