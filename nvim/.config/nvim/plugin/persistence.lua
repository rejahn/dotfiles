vim.pack.add({
	"https://github.com/folke/persistence.nvim",
})

require("persistence").setup({
	options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
})

vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore Session" })

vim.keymap.set("n", "<leader>qS", function()
	require("persistence").select()
end, { desc = "Select Session" })

vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })

vim.keymap.set("n", "<leader>qd", function()
	require("persistence").stop()
end, { desc = "Stop Session Saving" })
