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

require("lazy").setup("plugins")

--vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--	callback = function()
--		require("lint").try_lint()
--	end,
--})

-- mappings
vim.keymap.set("i", "<C-Right>", "<Plug>(copilot-accept-word)")
vim.keymap.set("v", "<C-A-c>", '"+y', { noremap = true, silent = true })

vim.keymap.set("n", "ff", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "fg", require("telescope.builtin").live_grep, {})
vim.keymap.set("n", "fb", require("telescope.builtin").buffers, {})

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "]g", vim.lsp.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.lsp.diagnostic.goto_prev)
-- vim.keymap.set("n", "gf", )

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true, silent = true })

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
