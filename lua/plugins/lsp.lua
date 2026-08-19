return {
	-- LSP and Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local keymap = vim.keymap

			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, opts)
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, opts)
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				opts.desc = "Toggle inlay hints"
				keymap.set("n", "<leader>ih", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
					vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
				end, opts)
			end

			local servers = {
				"lua_ls",
				"kotlin_language_server",
				"html",
				"cssls",
				"tailwindcss",
				"ts_ls",
				"svelte",
				"prismals",
				"graphql",
				"emmet_ls",
				"pyright",
				"terraformls",
				"rust_analyzer",
				"gradle_ls",
				"elixirls",
			}

			-- mason-lspconfig v2 removed the `handlers` option: server configs are
			-- declared via vim.lsp.config and started by automatic_enable
			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("kotlin_language_server", {
				root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git" },
				settings = {
					kotlin = { jvmTarget = "21" },
				},
			})

			vim.lsp.config("svelte", {
				-- a server-specific on_attach replaces the "*" one, so chain it here
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							if client.name == "svelte" then
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
							end
						end,
					})
				end,
			})

			vim.lsp.config("gradle_ls", {
				root_markers = { "settings.gradle", "build.gradle" },
			})

			-- Resolve the project interpreter so pyright sees project deps
			-- instead of the global python: an activated VIRTUAL_ENV wins,
			-- else search upward for .venv/venv (uv creates .venv at the
			-- project root — or the workspace root, hence the upward search)
			local function find_python(root_dir)
				if vim.env.VIRTUAL_ENV then
					return vim.env.VIRTUAL_ENV .. "/bin/python"
				end
				if not root_dir then
					return nil
				end
				local venv = vim.fs.find({ ".venv", "venv" }, {
					path = root_dir,
					upward = true,
					type = "directory",
				})[1]
				return venv and (venv .. "/bin/python") or nil
			end

			vim.lsp.config("pyright", {
				root_markers = {
					"pyproject.toml",
					"uv.lock",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
				},
				-- on_init (not before_init): client.settings is what nvim sends
				-- in the post-init didChangeConfiguration, and it must be
				-- mutated, not replaced
				on_init = function(client)
					local python = find_python(client.root_dir)
					if python then
						client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, {
							pythonPath = python,
						})
					end
				end,
			})

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				-- automatic_enable turns on every mason-installed server, not just
				-- the ones above; snyk-ls segfaults unauthenticated, the installed
				-- stylua binary doesn't support LSP mode (exit code 2),
				-- java_language_server would double up with jdtls on java buffers,
				-- and ruff is installed only as conform's formatter — drop it from
				-- this exclude to also get its lint diagnostics as an LSP
				automatic_enable = { exclude = { "snyk_ls", "stylua", "java_language_server", "ruff" } },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			-- Diagnostic symbols
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},

	-- Autocompletion, etc. (rest of the file is unchanged)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
			})
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			})
		end,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
	},
}
