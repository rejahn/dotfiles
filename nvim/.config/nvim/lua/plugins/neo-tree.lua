return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                hijack_netrw_behavior = "disabled",
                filtered_items = {
                    visible = true,
                    show_hidden_count = true,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = {
                        ".git",
                        ".DS_Store",
                        "thumbs.db",
                    },
                    never_show = {},
                },
            },
        })

        -- Toggle Neo-tree with Ctrl+n
        vim.keymap.set("n", "<C-n>", function()
            require("neo-tree.command").execute({
                toggle = true,
                source = "filesystem",
                position = "left",
                reveal = true,
            })
        end, {})
    end,
}
