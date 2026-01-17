vim.g.mapleader = " "
vim.g.background = "dark"
vim.g.colorscheme = "kanagawa"

-- line numbers setting
vim.wo.relativenumber = true
vim.wo.number = true

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.o.clipboard = "unnamedplus"
vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- comments
vim.keymap.set({ "n", "v" }, "<leader>c", "gcc", { remap = true, desc = "Toggle comment" })

-- map for quick quit, save files using leader key
vim.keymap.set('n', '<Leader>w', ':write<CR>')
vim.keymap.set('n', '<Leader>x', ':wq<CR>')

-- setup diagnostics as virtual lines
vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

-- code actions
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action", silent = true })
