local opts = {
    inlay_hints = {
        inline = true,
    },
}

vim.api.nvim_create_autocmd("FileType", {
    once = true,
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function()
        vim.pack.add({
            "https://github.com/p00f/clangd_extensions.nvim",
        })

        require("lsp.cpp").setup_clangd_extensions(opts)
    end,
})
