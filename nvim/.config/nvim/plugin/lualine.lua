vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = " ", right = " " },
        section_separators = { left = " ", right = " " },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
            {
                "lsp_status",
                icon = "",
                show_name = false,
                symbols = {
                    done = "",
                    separator = "",
                },
            },
            { "filename", path = 1 },
        },
        lualine_x = {
            "",
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn" },
                symbols = {
                    error = "●",
                    warn = "●",
                },
                colored = true,
                update_in_insert = false,
                always_visible = false,
            },
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
