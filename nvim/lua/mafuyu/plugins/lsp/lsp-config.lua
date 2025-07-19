return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

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
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Servers {{{

		-- Lua {{{
		vim.lsp.config.lua_ls = {
			cmd = { "lua_ls" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "require" },
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}
		vim.lsp.enable("lua_ls")
		-- }}}

		-- Python {{{
		vim.lsp.config.basedpyright = {
			name = "basedpyright",
			filetypes = { "python" },
			cmd = { "basedpyright-langserver", "--stdio" },
			settings = {
				python = {
					venvPath = vim.fn.expand("~") .. "/.virtualenvs",
				},
				basedpyright = {
					disableOrganizeImports = true,
					analysis = {
						autoSearchPaths = true,
						autoImportCompletions = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						typeCheckingMode = "strict",
						inlayHints = {
							variableTypes = true,
							callArgumentNames = true,
							functionReturnTypes = true,
							genericTypes = false,
						},
					},
				},
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function()
				local ok, venv = pcall(require, "rj.extras.venv")
				if ok then
					venv.setup()
				end
				local root = vim.fs.root(0, {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
					vim.uv.cwd(),
				})
				local client = vim.lsp.start(
					vim.tbl_extend("force", vim.lsp.config.basedpyright, { root_dir = root }),
					{ attach = false }
				)
				if client then
					vim.lsp.buf_attach_client(0, client)
				end
			end,
		})
		-- }}}

		-- Go {{{
		-- vim.lsp.config.gopls = {
		-- 	cmd = { "gopls" },
		-- 	filetypes = { "go", "gotempl", "gowork", "gomod" },
		-- 	root_markers = { ".git", "go.mod", "go.work", vim.uv.cwd() },
		-- 	settings = {
		-- 		gopls = {
		-- 			completeUnimported = true,
		-- 			usePlaceholders = true,
		-- 			analyses = {
		-- 				unusedparams = true,
		-- 			},
		-- 			["ui.inlayhint.hints"] = {
		-- 				compositeLiteralFields = true,
		-- 				constantValues = true,
		-- 				parameterNames = true,
		-- 				rangeVariableTypes = true,
		-- 			},
		-- 		},
		-- 	},
		-- }
		-- vim.lsp.enable("gopls")
		-- }}}

		-- C/C++ {{{
		vim.lsp.config.clangd = {
			cmd = {
				"clangd",
				"-j=" .. 2,
				"--background-index",
				"--clang-tidy",
				"--inlay-hints",
				"--fallback-style=llvm",
				"--all-scopes-completion",
				"--completion-style=detailed",
				"--header-insertion=iwyu",
				"--header-insertion-decorators",
				"--pch-storage=memory",
			},
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			root_markers = {
				"CMakeLists.txt",
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				".git",
				vim.uv.cwd(),
			},
		}
		vim.lsp.enable("clangd")
		-- }}}

		-- Rust {{{
		vim.lsp.config.rust_analyzer = {
			filetypes = { "rust" },
			cmd = { "rust-analyzer" },
			workspace_required = true,
			root_dir = function(buf, cb)
				local root = vim.fs.root(buf, { "Cargo.toml", "rust-project.json" })
				local out = vim.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" }, { cwd = root })
					:wait()
				if out.code ~= 0 then
					return cb(root)
				end

				local ok, result = pcall(vim.json.decode, out.stdout)
				if ok and result.workspace_root then
					return cb(result.workspace_root)
				end

				return cb(root)
			end,
			settings = {
				autoformat = false,
				["rust-analyzer"] = {
					check = {
						command = "clippy",
					},
				},
			},
		}
		vim.lsp.enable("rust_analyzer")
		-- }}}

		-- Typst {{{
		-- vim.lsp.config.tinymist = {
		-- 	cmd = { "tinymist" },
		-- 	filetypes = { "typst" },
		-- 	root_markers = { ".git", vim.uv.cwd() },
		-- }
		--
		-- vim.lsp.enable("tinymist")
		-- }}}

		-- Bash {{{
		vim.lsp.config.bashls = {
			cmd = { "bash-language-server", "start" },
			filetypes = { "bash", "sh", "zsh" },
			root_markers = { ".git", vim.uv.cwd() },
			settings = {
				bashIde = {
					globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
				},
			},
		}
		vim.lsp.enable("bashls")
		-- }}}

		-- Web-dev {{{
		-- TSServer {{{
		vim.lsp.config.ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

			init_options = {
				hostInfo = "neovim",
			},
		}
		-- }}}

		-- CSSls {{{
		vim.lsp.config.cssls = {
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = { "css", "scss" },
			root_markers = { "package.json", ".git" },
			init_options = {
				provideFormatter = true,
			},
		}
		-- }}}

		-- TailwindCss {{{
		vim.lsp.config.tailwindcssls = {
			cmd = { "tailwindcss-language-server", "--stdio" },
			filetypes = {
				"ejs",
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			root_markers = {
				"tailwind.config.js",
				"tailwind.config.cjs",
				"tailwind.config.mjs",
				"tailwind.config.ts",
				"postcss.config.js",
				"postcss.config.cjs",
				"postcss.config.mjs",
				"postcss.config.ts",
				"package.json",
				"node_modules",
			},
			settings = {
				tailwindCSS = {
					classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
					includeLanguages = {
						eelixir = "html-eex",
						eruby = "erb",
						htmlangular = "html",
						templ = "html",
					},
					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidConfigPath = "error",
						invalidScreen = "error",
						invalidTailwindDirective = "error",
						invalidVariant = "error",
						recommendedVariantOrder = "warning",
					},
					validate = true,
				},
			},
		}
		-- }}}

		-- HTML {{{
		vim.lsp.config.htmlls = {
			cmd = { "vscode-html-language-server", "--stdio" },
			filetypes = { "html" },
			root_markers = { "package.json", ".git" },

			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
				provideFormatter = true,
			},
		}
		-- }}}

		vim.lsp.enable({ "ts_ls", "cssls", "tailwindcssls", "htmlls" })

		-- }}}

		-- }}}
	end,
}
