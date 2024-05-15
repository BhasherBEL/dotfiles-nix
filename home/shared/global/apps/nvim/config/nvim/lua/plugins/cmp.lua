return {
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
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
		},

		config = function(_, opts)
			require("cmp").setup(opts)
		end,
		opts = function()
			local cmp = require("cmp")

			local options = {
				preselect = cmp.PreselectMode.Item,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "luasnip" },
					{ name = "tailwindcss-colorizer-cmp" },
				},
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<S-CR>"] = cmp.mapping.confirm({ select = true }),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			}
			return options
		end,
	},
}
