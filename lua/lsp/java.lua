-- ~/.config/nvim/lua/lsp/java.lua

local jdtls = require("jdtls")
local home = os.getenv("HOME")
local workspace_dir = home .. "/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

-- Determine OS
local os_config = "linux"
if vim.fn.has("macunix") == 1 then
	os_config = "mac"
elseif vim.fn.has("win32") == 1 then
	os_config = "win"
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Get the path to the JDTLS installation via Mason
local mason_registry = require("mason-registry")
local jdtls_pkg = mason_registry.get_package("jdtls")
local jdtls_path = jdtls_pkg:get_install_path()

-- Use JAVA_HOME to get the current Java Home
local java_home = os.getenv("JAVA_HOME") or ""
local java_executable = java_home .. "/bin/java"

-- Get the Java version (extract major version number)
local java_version_output = vim.fn.system(java_executable .. " -version 2>&1")
local java_version = java_version_output:match('java version "(%d+)[%.%d]*"')

-- Debugging: Print the extracted Java version
print("Extracted Java Version:", java_version)

if not java_version then
	-- Handle error if version extraction fails
	vim.notify("Failed to extract Java version", vim.log.levels.ERROR)
	return
end

local config = {
	cmd = {
		java_executable,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/java/lombok.jar",
		"-Xbootclasspath/a:" .. home .. "/.local/share/java/lombok.jar",
		"-jar",
		vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		jdtls_path .. "/config_" .. os_config,
		"-data",
		workspace_dir,
	},
	root_dir = require("jdtls.setup").find_root({
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts",
	}),
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-" .. java_version, -- Should be 'JavaSE-21'
						path = java_home,
					},
				},
			},
		},
	},
	init_options = {
		bundles = {},
	},
	capabilities = capabilities,
}

config["on_attach"] = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	jdtls.setup.add_commands()

	local opts = { noremap = true, silent = true }
	local keymap = vim.keymap

	opts.buffer = bufnr

	-- set keybinds
	opts.desc = "Show LSP references"
	keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

	opts.desc = "Go to declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

	opts.desc = "Show LSP definitions"
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

	opts.desc = "Show LSP implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

	opts.desc = "Show LSP type definitions"
	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

	opts.desc = "See available code actions"
	keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

	opts.desc = "Smart rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

	opts.desc = "Show buffer diagnostics"
	keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

	opts.desc = "Show line diagnostics"
	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

	opts.desc = "Go to previous diagnostic"
	keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

	opts.desc = "Go to next diagnostic"
	keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

	opts.desc = "Show documentation for what is under cursor"
	keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end

-- Start or attach
jdtls.start_or_attach(config)
