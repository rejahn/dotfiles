vim.pack.add({
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/marko-cerovac/material.nvim",
})

require("material").setup({
	disable = {
		colored_cursor = true, -- Keep the guicursor configured in options.lua.
	},
	plugins = {
		"blink",
		"mini",
		"nvim-web-devicons",
	},
})

vim.cmd.colorscheme("material-deep-ocean")
