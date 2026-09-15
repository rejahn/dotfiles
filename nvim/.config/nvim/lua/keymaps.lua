-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- map for quick quit, save files using leader key
vim.keymap.set("n", "<Leader>w", ":write<CR>")
vim.keymap.set("n", "<Leader>x", ":wq<CR>")

-- code actions
vim.keymap.set("n", "<leader>a", function()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.lsp.buf.code_action({
		range = {
			start = { row, 0 },
			["end"] = { row, #vim.api.nvim_get_current_line() },
		},
	})
end, { desc = "Code actions", silent = true })

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart config :restart)" })

-- improve indentation
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- centered cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })
