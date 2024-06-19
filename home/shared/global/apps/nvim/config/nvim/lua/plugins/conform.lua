return {
	{
		-- Formatter
		"stevearc/conform.nvim",
		opts = {},
		config = function()
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
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
				notify_on_error = true,
				log_level = vim.log.levels.DEBUG,
			})
		end,
	},
}
