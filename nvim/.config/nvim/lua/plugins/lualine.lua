return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "folke/noice.nvim",
    },
    config = function()
        local function noice_lsp_spinner()
            local ok, noice = pcall(require, "noice")
            if not ok then
                return ""
            end

            local hl = noice.api.status.lsp_progress.get_hl()
            if not hl or hl == "" then
                return ""
            end

            local spinner = hl:match("%%#NoiceLspProgressSpinner#([^%%]+)")
            if spinner and spinner ~= "" then
                return "%#NoiceLspProgressSpinner#" .. vim.trim(spinner)
            end

            return ""
        end

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
                        noice_lsp_spinner,
                        cond = function()
                            local ok, noice = pcall(require, "noice")
                            return ok and noice.api.status.lsp_progress.has()
                        end,
                        padding = { left = 1, right = 1 },
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
