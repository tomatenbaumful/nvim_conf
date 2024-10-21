return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mfussenegger/nvim-dap",
			{
				"williamboman/mason.nvim",
				build = ":MasonUpdate",
			},
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
			"b0o/schemastore.nvim",
			{
				"mrcjkb/rustaceanvim",
				version = "^4",
			},
		},
		init = function()
			vim.diagnostic.config({
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = "󰌵",
					},
				},
			})

			vim.lsp.handlers["textDocument/hover"] =
				vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", title = "Hover" })

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		end,
		config = function()
			local function nmap(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
			nmap("<leader>a", vim.lsp.buf.code_action, "Code Action")
			nmap("gd", vim.lsp.buf.definition, "Goto Definition")
			nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
			nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
			nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
			nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Workspace Remove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "Workspace List Folders")

			nmap("gl", vim.diagnostic.open_float, "Open diagnostics")
			nmap("[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, "Previous diagnostic")
			nmap("]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, "Next diagnostic")

			-- VTLS COMMANDS
			nmap("<leader>t", function()
				require("vtsls").commands.add_missing_imports(0, function()
					require("vtsls").commands.fix_all(0, function()
						require("vtsls").commands.organize_imports(0)
					end)
				end)
			end, "VTSLS Do all")
			nmap("<leader>trn", function()
				require("vtsls").commands.rename_file(0)
			end, "VTSLS Rename file")

			local mason = require("mason")
			mason.setup({
				ui = { border = "rounded" },
			})

			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			-- ########################### NEODEV ###########################
			local neodev = require("neodev")
			neodev.setup()

			-- ########################### RUST ###########################
			vim.g.rustaceanvim = {
				server = {
					on_attach = function(client, bufnr)
						vim.keymap.set("n", "<leader>a", function()
							vim.cmd.RustLsp("codeAction")
						end, { buffer = bufnr, desc = "RustLsp Code Action", silent = true })
					end,
				},
			}

			-- ########################### LSP ###########################
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local servers = {
				-- tailwindcss = {},
				cssls = {},
				-- clangd = {},
				jsonls = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
				emmet_language_server = {},
				angularls = {},
				eslint = {},
				vtsls = {},
				-- tsserver = {
				--   javascript = {
				--     format = {
				--       enable = false,
				--     },
				--   },
				--   typescript = {
				--     format = {
				--       enable = false,
				--     },
				--   },
				-- },
			}

			lspconfig.zls.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					completion = { callSnippet = "Replace" },
					diagnostics = {
						globals = { "vim" },
					},
					format = {
						enable = true,
						defaultConfig = {
							quote_style = "single",
							space_around_table_field_list = false,
							space_inside_square_brackets = false,
						},
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					-- "tailwindcss",
					"cssls",
					"jsonls",
					"emmet_language_server",
					"eslint",
					"html",
				},
				automatic_installation = true,
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						settings = servers[server_name],
					})
				end,
				["ts_ls"] = function() end,
				["tsserver"] = function() end,
				["angularls"] = function()
					lspconfig.angularls.setup({
						capabilities = capabilities,
						settings = servers.angularls,
						root_dir = lspconfig.util.root_pattern("angular.json", "project.json", "nx.json")
							or vim.fn.getcwd(),
						filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
					})
				end,
			})
		end,
	},
	"yioneko/nvim-vtsls",
}
