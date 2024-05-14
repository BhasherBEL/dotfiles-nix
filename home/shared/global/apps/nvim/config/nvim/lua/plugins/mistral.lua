return {
	{
		"BhasherBEL/Mistral.nvim",
		--event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "echo ''",
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
