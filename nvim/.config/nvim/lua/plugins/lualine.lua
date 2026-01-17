return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto",
                component_separators = { left = " ", right = " " },
                section_separators = { left = " ", right = " " },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {},
                lualine_c = { "filename" },

                lualine_x = {
                    "",

                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        sections = { "error", "warn" },
                        symbols = {
                            error = "●",
                            warn  = "●",
                        },
                        colored = true,
                        update_in_insert = false,
                        always_visible = false,
                    },

                    "filetype",
                },

                lualine_y = { "progress" },
                lualine_z = { "location" },
            }

        })
    end,
}
