return {
	{
		-- Ranger file explorer
		"kelly-lin/ranger.nvim",
		config = function()
			require("ranger-nvim").setup({ replace_netrw = true })
		end,
	},
}
