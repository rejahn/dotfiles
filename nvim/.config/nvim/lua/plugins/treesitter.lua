return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
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

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = false,
                        keymaps = {
                            -- Functions / classes
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",

                            -- Parameters / arguments
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",

                            -- Blocks
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",

                            -- Conditionals / loops
                            ["a?"] = "@conditional.outer",
                            ["i?"] = "@conditional.inner",
                            ["ao"] = "@loop.outer",
                            ["io"] = "@loop.inner",

                        },
                        include_surrounding_whitespace = true,
                    },

                    move = {
                        enable = true,
                        set_jumps = true,

                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",

                            -- extra nice-to-haves:
                            ["]a"] = "@parameter.inner",
                            ["]b"] = "@block.outer",
                            ["]?"] = "@conditional.outer",
                            ["]l"] = "@loop.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",

                            -- extra:
                            ["]A"] = "@parameter.inner",
                            ["]B"] = "@block.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",

                            -- extra:
                            ["[a"] = "@parameter.inner",
                            ["[b"] = "@block.outer",
                            ["[?"] = "@conditional.outer",
                            ["[l"] = "@loop.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",

                            -- extra:
                            ["[A"] = "@parameter.inner",
                            ["[B"] = "@block.outer",
                        },
                    },
                },
            })

            -- Repeatable movement with ; and ,
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            --  c  -- Optional: make builtin f/F/t/T also repeat with ; ,
            --     vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            --     vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            --     vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            --     vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
}
