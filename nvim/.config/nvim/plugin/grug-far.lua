vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

require("grug-far").setup({})

-- Restore the hidden command line after package installation/loading.
-- vim.o.cmdheight = 0

vim.keymap.set({ "n", "x" }, "<leader>sr", function()
	require("grug-far").open()
end, { desc = "Search and replace" })

vim.keymap.set({ "n", "x" }, "<leader>sR", function()
	require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and replace" })
