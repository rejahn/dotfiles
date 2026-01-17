return {
    {
        "williamboman/mason.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            automatic_installation = true,
            ensure_installed = {
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "clangd",
                "cmake",
                "autotools_ls",
                "ansiblels",
                "ruff",
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,

        dependencies = {
            "saghen/blink.cmp",
        },

        config = function()
            -- diagnostics
            vim.diagnostic.config({
                virtual_text = false,
                underline = false,
                update_in_insert = false,
                severity_sort = true,
                virtual_lines = { current_line = true },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "●",
                        [vim.diagnostic.severity.WARN]  = "●",
                        [vim.diagnostic.severity.HINT]  = "●",
                        [vim.diagnostic.severity.INFO]  = "●",
                    },
                },
            })

            -- on_attach: only LSP keymaps
            local on_attach = function(_, bufnr)
                --     vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Goto Definition" })
                -- vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename(), { nuffer = bufnr, desc = "Goto Definition" })
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol", })
                -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
                -- vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, nowait = true, desc = "References" })
                -- vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Goto Implementation" })
                -- vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto Type Definition" })
                -- vim.keymap.set("n", "gai", vim.lsp.buf.incoming_calls,  { buffer = bufnr, desc = "Incoming Calls" })
                -- vim.keymap.set("n", "gao", vim.lsp.buf.outgoing_calls,  { buffer = bufnr, desc = "Outgoing Calls" })
                vim.keymap.set("n", "ga", "<C-^>", { desc = "Go to alternate buffer" })
            end

            --  Format-on-save
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function(ev)
                    local ft = vim.bo[ev.buf].filetype
                    local preferred

                    if ft == "rust" then
                        preferred = "rust_analyzer"
                    elseif ft == "c" or ft == "cpp" or ft == "cuda" then
                        preferred = "clangd"
                    elseif ft == "python" then
                        preferred = "pyright"
                    end

                    vim.lsp.buf.format({
                        async = false,
                        bufnr = ev.buf,
                        filter = function(client)
                            if preferred then
                                return client.name == preferred
                            end
                            return client.server_capabilities.documentFormattingProvider
                        end,
                    })
                end,
            })

            -- LSP SERVERS
            -- Lua
            vim.lsp.config("lua_ls", {
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            -- C / C++
            vim.lsp.config("clangd", { on_attach = on_attach })
            vim.lsp.enable("clangd")

            -- CMake
            vim.lsp.config("cmake", { on_attach = on_attach })
            vim.lsp.enable("cmake")

            -- Autotools
            vim.lsp.config("autotools_ls", { on_attach = on_attach })
            vim.lsp.enable("autotools_ls")

            -- Python
            vim.lsp.config("pyright", { on_attach = on_attach })
            vim.lsp.enable("pyright")

            -- Ruff
            vim.lsp.config("ruff", { on_attach = on_attach })
            vim.lsp.enable("ruff")

            -- Rust
            vim.lsp.config("rust_analyzer", {
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { features = "all" },
                        check = { command = "clippy" },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            -- Ansible
            vim.lsp.config("ansiblels", {
                on_attach = on_attach,
                settings = {
                    ansible = {
                        validation = {
                            enabled = true,
                            lint = {
                                enabled = true,
                            },
                        },
                    },
                },
            })
            vim.lsp.enable("ansiblels")
        end,
    },
}
