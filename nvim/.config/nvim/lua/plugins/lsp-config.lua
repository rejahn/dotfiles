return {
    {
        "williamboman/mason.nvim",
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
                -- core
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "clangd",
                "cmake",
                "autotools_ls",

                -- extra
                "ansiblels",
                "ruff",
            },
        },
    },

    -- completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            -- capabilities (for nvim-cmp)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

            -- diagnostics
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = false,
                update_in_insert = false,
                severity_sort = true,
                virtual_lines = { current_line = true },
            })

            local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end


            -- on_attach: per-buffer keymaps & behaviour
            local on_attach = function(client, bufnr)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", silent = true })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition", silent = true })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration", silent = true })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation", silent = true })
                vim.keymap.set("n", "ga", "<C-^>", { desc = "Alternate file", silent = true })
                vim.keymap.set("n", "gh", vim.lsp.buf.references, { desc = "Symbol References", silent = true })
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true })
                vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action", silent = true })
                vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help,
                    { desc = "Signature help", silent = true })

                if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                    pcall(vim.lsp.inlay_hint.enable, false,
                        { bufnr = bufnr })
                end

                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end

            -- format on save, preferring specific servers per language
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

            -- LSP server configurations

            -- Lua
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            -- C / C++
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("clangd")

            -- CMake
            vim.lsp.config("cmake", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("cmake")

            -- Autotools
            vim.lsp.config("autotools_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("autotools_ls")

            -- Python (pyright)
            vim.lsp.config("pyright", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("pyright")

            -- Ruff
            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ruff")

            -- Rust
            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            features = "all",
                        },
                        checkOnSave = {
                            enable = true,
                        },
                        check = {
                            command = "clippy",
                        },
                        imports = {
                            group = {
                                enable = false,
                            },
                        },
                        completion = {
                            postfix = {
                                enable = false,
                            },
                        },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            -- Ansible
            vim.lsp.config("ansiblels", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ansible = {
                        ansible = {
                            useFullyQualifiedCollectionNames = true,
                        },
                        python = {
                            interpreterPath = "python",
                        },
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
