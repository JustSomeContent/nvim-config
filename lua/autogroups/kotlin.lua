-- autogroups/kotlin.lua

-- utility functions
local function file_exists(filepath)
	return vim.fn.filereadable(filepath) == 1
end

-- Function to generate the corresponding test file path
local function get_test_file_path()
	-- Get the full path of the currently open file
	local current_file_path = vim.fn.expand("%:p") -- e.g., /path/to/project/src/main/kotlin/com/example/MyClass.kt

	-- Replace '/main/' with '/test/' in the file path
	local test_file_path = string.gsub(current_file_path, "/main/", "/test/")

	-- Replace the '.kt' or '.kts' or '.java' extension with 'Test.kt', 'Test.kts', 'Test.java'
	test_file_path = string.gsub(test_file_path, "%.([kK][tT][sS]?)$", "Test.%1")

	return test_file_path
end

-- Function to extract the package name from the test file path
local function get_package_name(filepath)
	-- Pattern to match everything after '/test/kotlin/' and before the filename
	local package_path = string.match(filepath, "/test/kotlin/(.+)/[^/]+Test.kt$")

	if not package_path then
		-- Fallback if the pattern doesn't match
		return "com.example"
	end

	-- Replace '/' with '.' to form the package name
	local package_name = string.gsub(package_path, "/", ".")

	return package_name
end

-- Function to ensure the directory exists
local function ensure_directory_exists(filepath)
	local dir = vim.fn.fnamemodify(filepath, ":h") -- Extract the directory path

	-- Use Vim's mkdir function with 'p' flag to create parent directories
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p") -- Create the directory along with parents
	end
end

-- Function to insert a test class template
local function insert_test_template(filepath)
	local package_name = get_package_name(filepath)
	local class_name = vim.fn.expand("%:t:r") -- Extract the filename without extension

	-- Determine the file extension
	local ext = vim.fn.expand("%:e")

	-- Define template based on file extension
	local template = {}
	if ext == "kt" or ext == "kts" then
		template = {
			"package " .. package_name,
			"",
			"import org.assertj.core.api.Assertions.assertThat",
			"import org.junit.jupiter.api.Test",
			"",
			"class " .. class_name .. " {",
			"    @Test",
			"    fun testFunction() {",
			"        assertThat(true).isEqualTo(false)",
			"    }",
			"}",
		}
	elseif ext == "java" then
		template = {
			"package " .. package_name .. ";",
			"",
			"import org.assertj.core.api.Assertions.assertThat;",
			"import org.junit.jupiter.api.Test;",
			"",
			"public class " .. class_name .. " {",
			"    @Test",
			"    public void testFunction() {",
			"        assertThat(true).isEqualTo(false);",
			"    }",
			"}",
		}
	else
		-- Default template for other file types
		template = {
			"// TODO: Implement test for " .. class_name,
		}
	end

	-- Insert the template into the buffer
	vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
end

-- Main function to create or open the test file
local function create_or_open_testfile()
	-- Generate the test file path
	local test_file_path = get_test_file_path()

	-- Check if the current file is saved
	if test_file_path == "" then
		return
	end

	local existing_win = nil
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_path = vim.api.nvim_buf_get_name(buf)
		if buf_path == get_test_file_path() then
			existing_win = win
			break
		end
	end

	if existing_win then
		-- If the test file is already open in a window, jump to that window
		vim.api.nvim_set_current_win(existing_win)
	else
		-- Check if the test file exists
		if file_exists(test_file_path) then
			-- Open the test file in a vertical split to the right
			vim.cmd("vsplit " .. test_file_path)
		else
			-- Ensure the test directory exists
			ensure_directory_exists(test_file_path)

			-- Open the test file in a vertical split (creates a new buffer)
			vim.cmd("vsplit " .. test_file_path)

			-- Insert a basic test class template
			insert_test_template(test_file_path)
		end
	end
end

return { create_or_open_testfile = create_or_open_testfile }
