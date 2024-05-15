return {
	{
		-- TODO: Remove
		-- java LSP client
		"mfussenegger/nvim-jdtls",
	},
	{
		-- LSP
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		dependencies = {
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-path",
					"L3MON4D3/LuaSnip",
					"saadparwaiz1/cmp_luasnip",
				},
			},
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local servers = { "nil_ls", "gopls", "svelte", "tsserver", "tailwindcss", "clangd" }
			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					capabilities = capabilities,
					autoformat = true,
				})
			end

			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				autoformat = true,
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})

			require("lspconfig").pyright.setup({
				venvPath = "venv",
				capabilities = capabilities,
				autoformat = true,
			})
			require("lspconfig").jdtls.setup({
				--root_dir = require("jdtls.setup").find_root({
				--	"build.gradle",
				--	"pom.xml",
				--	"gradlew",
				--	"mvnw",
				--	".git",
				--}),
				capabilities = capabilities,
				autoformat = true,
				settings = {
					java = {
						signatureHelp = { enabled = true },
						contentProvider = { preferred = "fernflower" },
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},
					},
				},
				cmd = {
					"jdtls",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xmx4g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
				},
			})
			require("lspconfig").ltex.setup({
				capabilities = capabilities,
				autoformat = true,
				settings = {
					filetypes = { "." },
					ltex = {
						language = "en-GB",
						additionalRules = {
							languageModel = "~/models/ngrams/",
						},
					},
				},
			})
			require("lspconfig").marksman.setup({
				capabilities = capabilities,
				autoformat = true,
			})
		end,
	},
}
