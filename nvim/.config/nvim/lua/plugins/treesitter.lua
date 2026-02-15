return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                ensure_installed = {
                    "c",
                    "cpp",
                    "sql",
                    "yaml",
                    "json",
                    "lua",
                    "python",
                    "rust",
                    "vim",
                    "vimdoc",
                    "query",
                },
                highlight = { enable = true },
                indent = { enable = false },
            })
        end,
    },
}
