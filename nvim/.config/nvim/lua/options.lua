vim.g.mapleader = " "
vim.g.background = "dark"

vim.o.termguicolors = true

vim.g.netrw_banner = 0

-- line numbers setting
vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = "auto"
vim.o.cmdheight = 0
vim.opt.more = false
vim.o.clipboard = "unnamedplus"
-- vim.opt.guicursor = ""
vim.opt.scrolloff = 10

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
-- vim.opt.undofile = true

-- one status line, even on vsplits.
vim.opt.laststatus = 3

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- setup diagnostics as virtual lines
vim.diagnostic.config({ virtual_text = true, virtual_lines = { current_line = true } })
