return {
	-- Parser
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = true,
		config = function()
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
		end,
	},
}
