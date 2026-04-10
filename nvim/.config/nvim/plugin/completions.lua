vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets",
    {
        src = "https://github.com/Saghen/blink.cmp",
        version = vim.version.range("1.x"),
    },
})

require("blink.cmp").setup({
    keymap = { preset = "enter" },
    completion = { documentation = { auto_show = true } },
})
