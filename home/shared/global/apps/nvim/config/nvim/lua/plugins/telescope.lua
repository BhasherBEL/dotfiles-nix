return {
	{
		-- Fuzzy finder
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { ".git/", "node_modules/", "venv/" },
				},
			})
		end,
	},
}
