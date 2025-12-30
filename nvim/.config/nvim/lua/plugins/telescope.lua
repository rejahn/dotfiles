return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },

        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                    },
                    file_ignore_patterns = {
                        "%.git/",
                        "%.cache/",
                        "build/",
                        "target/",
                        "%.o",
                        "%.a",
                    },
                },

                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown({}),
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")

            -- Keymaps
            vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>F", builtin.git_files, { desc = "Git files" })
            vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>j", builtin.jumplist, { desc = "Jumplist" })
            vim.keymap.set("n", "<leader>g", builtin.git_status, { desc = "Git status" })
            vim.keymap.set("n", "<leader>'", builtin.resume, { desc = "Resume last picker" })
            vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>?", builtin.commands, { desc = "Commands" })
            vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
            vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "Help tags" })

            vim.keymap.set("n", "<leader>d", function()
                builtin.diagnostics({ bufnr = 0 })
            end, { desc = "Document Diagnostics" })

            vim.keymap.set("n", "<leader>D", builtin.diagnostics, { desc = "Workspace diagnostics" })

            -- Document symbols (current file)
            vim.keymap.set(
                "n",
                "<leader>s",
                builtin.lsp_document_symbols,
                { desc = "Document symbols" }
            )

            -- Workspace symbols
            vim.keymap.set(
                "n",
                "<leader>S",
                builtin.lsp_workspace_symbols,
                { desc = "Workspace symbols" }
            )

            vim.keymap.set("n", "<leader>a", function()
                builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                    no_ignore_parent = true,
                    follow = true,
                })
            end, { desc = "Find ALL files (no ignore)" })
        end,
    },
}
