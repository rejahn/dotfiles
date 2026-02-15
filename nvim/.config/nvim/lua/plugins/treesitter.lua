return {
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "c",
                "cpp",
                "sql",
                "yaml",
                "json",
                "lua",
                "vim",
                "vimdoc",
                "python",
                "javascript",
                "typescript",
                "rust",
                "bash",
                "markdown",
            },

            auto_install = true,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "<S-CR>",
                    node_decremental = "<BS>",
                },
            },
        })
    end,
}
