return {
	{
		"BhasherBEL/Mistral.nvim",
		--event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "echo 'G5aUAKGcxklpCShv0b1c1zoJjiYgYPj2'",
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}
