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
                "rust_analyzer",
                "clangd",
                "autotools_ls",
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
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol", })
                vim.keymap.set("n", "ga", "<C-^>", { desc = "Go to alternate buffer" })
            end

            --  Format-on-save
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function(ev)
                    local ft = vim.bo[ev.buf].filetype
                    local preferred

                    if ft == "rust" then
                        preferred = "rust_analyzer"
                    elseif ft == "c" or ft == "cpp" then
                        preferred = "clangd"
                    elseif ft == "python" then
                        preferred = "ruff"
                    end

                    vim.lsp.buf.format({
                        async = false,
                        bufnr = ev.buf,
                        filter = function(client)
                            if preferred == "ruff" then
                                return client.name == "ruff"
                                    and client.server_capabilities
                                    and client.server_capabilities.documentFormattingProvider
                            end
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

            -- Autotools
            vim.lsp.config("autotools_ls", { on_attach = on_attach })
            vim.lsp.enable("autotools_ls")

            -- Python
            vim.lsp.config("ty", {
                on_attach = on_attach,
                cmd = { "ty", "server" },
                settings = {
                    ty = {},
                },
            })
            vim.lsp.enable("ty")

            vim.lsp.config("ruff", {
                on_attach = on_attach,
                cmd = { "ruff", "server" },
                init_options = {
                    settings = {
                        configurationPreference = "filesystemFirst",
                    },
                },
            })
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
        end,
    },
}
