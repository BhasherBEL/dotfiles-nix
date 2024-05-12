-- General options
vim.opt.compatible = false
vim.opt.ignorecase = true
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.expandtab = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wildmode = "longest,list"

vim.opt.syntax = "on"

vim.opt.ttyfast = true
vim.opt.swapfile = false
vim.opt.mouse = "a"

vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.spelllang = "en" -- ,fr'
vim.api.nvim_set_hl(0, "SpellBad", { ctermbg = 238 })

vim.cmd([[colorscheme desert]])

vim.g.clipboard = {
	name = "wl-clipboard",
	copy = { ["+"] = "wl-copy --trim-newline", ["*"] = "wl-copy --trim-newline" },
	paste = { ["+"] = "wl-paste", ["*"] = "wl-paste" },
	cache_enabled = 0,
}

-- Plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		"--depth=1",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--{
	-- Auto completion
	--	"neoclide/coc.nvim",
	--	branch = "release",
	--},
	{
		-- Parser
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		-- Copilot
		"github/copilot.vim",
		-- config = function()
		--	require("copilot.vim").setup({
		--		filetypes = {
		--			["."] = true,
		--		},
		--	})
		--end,
	},
	{
		-- Ranger file explorer
		"kelly-lin/ranger.nvim",
		config = function()
			require("ranger-nvim").setup({ replace_netrw = true })
		end,
	},
	{
		-- Formatter
		"stevearc/conform.nvim",
		opts = {},
	},
	{
		-- Auto pairs
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recommended as each new version will have breaking changes
		opts = {},
	},
	{
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
				},
			},
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			local servers = { "nil_ls", "lua_ls", "gopls", "svelte", "tsserver", "tailwindcss", "clangd" }
			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					capabilities = capabilities,
					autoformat = true,
				})
			end

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
		end,
	},
	{
		-- Fuzzy finder
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		-- Autotag
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		-- Colorize tailwindcss menu
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({})
		end,
	},
	{

		-- Autocompletion
		"hrsh7th/nvim-cmp",
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
		},
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
		opts = function()
			local cmp = require("cmp")

			local options = {
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					-- { name = "tailwindcss-colorizer-cmp" },
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
			}
			return options
		end,
	},
	{
		-- Colorizer
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({})
		end,
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		svelte = { { "prettierd", "prettier" } },
		html = { { "prettierd", "prettier" } },
		css = { { "prettierd", "prettier" } },
		md = { { "prettierd", "prettier" } },
		less = { { "prettierd", "prettier" } },
		scss = { { "prettierd", "prettier" } },
		json = { { "prettierd", "prettier" } },
		yaml = { { "prettierd", "prettier" } },
		toml = { { "prettierd", "prettier" } },
		java = { "google-java-format" },
		nix = { "nixfmt" },
		c = { "clang-format" },
		go = { "gofmt" },
	},
	format_on_save = {},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"go",
		"lua",
		"vim",
		"vimdoc",
		"sql",
		"json",
		"javascript",
		"typescript",
		"svelte",
		"html",
		"java",
		"markdown",
		"nix",
		"c",
		"cpp",
	},
	highlight = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
})

--vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--	callback = function()
--		require("lint").try_lint()
--	end,
--})

-- mappings
vim.keymap.set("i", "<C-Right>", "<Plug>(copilot-accept-word)")
vim.keymap.set("v", "<C-A-c>", '"+y', { noremap = true, silent = true })

vim.keymap.set("n", "ff", require("telescope.builtin").find_files, {})

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
-- vim.keymap.set("n", "gf", )

vim.keymap.set("n", "gf", vim.diagnostic.open_float, { noremap = true, silent = true })

-- commands
vim.api.nvim_create_user_command("Day", function(opts)
	vim.cmd([[colorscheme delek]])
end, { nargs = 0 })

vim.api.nvim_create_user_command("Night", function(opts)
	vim.cmd([[colorscheme desert]])
end, { nargs = 0 })

-- auto resize splits
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd([[wincmd =]])
	end,
})
