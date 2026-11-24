vim.pack.add({
	{
		src = "https://github.com/Saecki/crates.nvim",
		version = "stable",
	},
})

require("crates").setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
})
