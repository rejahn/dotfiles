vim.pack.add({
	"https://github.com/akinsho/bufferline.nvim",
})

vim.opt.termguicolors = true

require("bufferline").setup({
	options = {
		always_show_bufferline = false,
		separator_style = "thin",

		modified_icon = "+",

		show_buffer_icons = false,
		show_buffer_close_icons = false,
		show_close_icon = false,
	},
})

require("keymaps").bufferline()
