return {
    "folke/snacks.nvim",
    dependencies = {
        "folke/which-key.nvim",
        {
            "folke/todo-comments.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            opts = {},
        },
    },
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
        bigfile      = { enabled = true },
        explorer     = { enabled = true },
        git          = { enabled = true },
        input        = { enabled = true },
        quickfile    = { enabled = true },
        scroll       = { enabled = false },
        statuscolumn = { enabled = false },
        words        = { enabled = false },
        toggle       = { enabled = true },

        picker       = {
            enabled = true,
            sources = {
                files = {
                    hidden = true,
                    ignored = true,
                    follow = false,
                    exclude = {
                        ".git/",
                        "node_modules/",
                        ".cache/",
                        "build/",
                        "dist/",
                        "target/",
                    },
                },
                grep = {
                    hidden = true,
                    ignored = false,
                    exclude = {
                        ".git/",
                        "node_modules/",
                        ".cache/",
                        "build/",
                        "dist/",
                        "target/",
                    },
                },
            },
        },

        -- indent
        indent       = {
            enabled = true,
            animate = {
                enabled = false,
            },
            indent = {
                char = "┊",
            },

            scope = {
                enabled = false,
            },
        },
    },

    config = function(_, opts)
        local Snacks = require("snacks")
        Snacks.setup(opts)
    end,

    keys = {
        -- files
        { "<leader>f",        function() Snacks.picker.files() end,                                                  desc = "Find files" },
        -- buffers / jumps
        { "<leader>b",        function() Snacks.picker.buffers() end,                                                desc = "Buffers" },
        { "<leader>j",        function() Snacks.picker.jumps() end,                                                  desc = "Jumplist" },
        -- git
        { "<leader>g",        function() Snacks.picker.git_status() end,                                             desc = "Git status" },
        { "<leader>gb",       function() Snacks.picker.git_branches() end,                                           desc = "Git Branches" },
        { "<leader>gl",       function() Snacks.picker.git_log() end,                                                desc = "Git Log" },
        { "<leader>gL",       function() Snacks.picker.git_log_file() end,                                           desc = "Git Log Line" },
        { "<leader>gs",       function() Snacks.picker.git_status() end,                                             desc = "Git Status" },
        { "<leader>gS",       function() Snacks.picker.git_stash() end,                                              desc = "Git Stash" },
        { "<leader>gd",       function() Snacks.picker.git_diff() end,                                               desc = "Git Diff (Hunks)" },
        { "<leader>gB",       function() Snacks.git.blame_line() end,                                                desc = "Git Blame Line" },
        { "<leader>gf",       function() Snacks.picker.git_log_file() end,                                           desc = "Git Log File" },
        -- misc pickers
        { "<leader>:",        function() Snacks.picker.command_history() end,                                        desc = "Command History" },
        { "<leader>'",        function() Snacks.picker.resume() end,                                                 desc = "Resume picker" },
        { "<leader>/",        function() Snacks.picker.grep() end,                                                   desc = "Live grep" },
        { "<leader>?",        function() Snacks.picker.commands() end,                                               desc = "Commands" },
        { "<leader><leader>", function() Snacks.picker.recent() end,                                                 desc = "Recent files" },
        { "<leader>H",        function() Snacks.picker.help() end,                                                   desc = "Help tags" },
        -- diagnostics / symbols
        { "<leader>d",        function() Snacks.picker.diagnostics_buffer() end,                                     desc = "Document diagnostics" },
        { "<leader>D",        function() Snacks.picker.diagnostics() end,                                            desc = "Workspace diagnostics" },
        { "<leader>s",        function() Snacks.picker.lsp_symbols() end,                                            desc = "Document symbols" },
        { "<leader>S",        function() Snacks.picker.lsp_workspace_symbols() end,                                  desc = "Workspace symbols" },
        -- LSP
        -- { "gd",               function() Snacks.picker.lsp_definitions() end,                                        desc = "Goto Definition" },
        -- { "gD",               function() Snacks.picker.lsp_declarations() end,                                       desc = "Goto Declaration" },
        -- { "gr",               function() Snacks.picker.lsp_references() end,                                         nowait = true,                 desc = "References" },
        -- { "gI",               function() Snacks.picker.lsp_implementations() end,                                    desc = "Goto Implementation" },
        -- { "gy",               function() Snacks.picker.lsp_type_definitions() end,                                   desc = "Goto Type Definition" },
        -- { "gai",              function() Snacks.picker.lsp_incoming_calls() end,                                     desc = "Incoming Calls" },
        -- { "gao",              function() Snacks.picker.lsp_outgoing_calls() end,                                     desc = "Outgoing Calls" },
        -- explorer toggle
        { "<leader>e",        function() Snacks.explorer() end,                                                      desc = "Explorer" },
        -- todo-comments integration
        { "<leader>t",        function() Snacks.picker.todo_comments() end,                                          desc = "Todo" },
        { "<leader>T",        function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
}
