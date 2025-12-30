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
                "html",

                -- extra
                "ansiblels",
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
            --------------------------------------------------------------------------
            -- capabilities (for nvim-cmp)
            --------------------------------------------------------------------------
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

            --------------------------------------------------------------------------
            -- diagnostics (clean UI)
            --------------------------------------------------------------------------
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = false,
                update_in_insert = false,
                severity_sort = true,
                virtual_lines = { current_line = true }
            })



            -- diagnostic signs
            local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end


            --------------------------------------------------------------------------
            -- on_attach: per-buffer keymaps & behaviour
            --------------------------------------------------------------------------
            local on_attach = function(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- LSP navigation / actions
                map("n", "K", vim.lsp.buf.hover, "Hover")
                map("n", "gd", vim.lsp.buf.definition, "Goto definition")
                map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
                map("n", "<leader>h", vim.lsp.buf.references, "References")
                map("n", "<leader>r", vim.lsp.buf.rename, "Rename symbol")
                map("n", "<leader>a", vim.lsp.buf.code_action, "Code action")

                map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

                map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature help")

                if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                    pcall(vim.lsp.inlay_hint.enable, false, { bufnr = bufnr })
                end

                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end

            --------------------------------------------------------------------------
            -- format on save, preferring specific servers per language
            --------------------------------------------------------------------------
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function(ev)
                    local ft = vim.bo[ev.buf].filetype

                    -- prefer certain servers per filetype
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

            --------------------------------------------------------------------------
            -- helper for configuring servers (Neovim 0.11+ API)
            --------------------------------------------------------------------------
            local function cfg(name, config)
                config = config or {}
                config.capabilities = capabilities
                config.on_attach = on_attach

                vim.lsp.config(name, config)
                vim.lsp.enable(name) -- auto-attach on matching filetypes, incl. new files
            end

            --------------------------------------------------------------------------
            -- Server configurations
            --------------------------------------------------------------------------
            -- JS / TS
            cfg("ts_ls")

            -- HTML
            cfg("html")

            -- Lua (nvim config)
            cfg("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- C / C++
            cfg("clangd")

            -- CMake
            cfg("cmake")

            -- Autotools
            cfg("autotools_ls")

            -- Python
            cfg("pyright")

            cfg("ruff")

            -- Rust
            cfg("rust_analyzer", {
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

            -- Ansible
            cfg("ansiblels", {
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
        end,
    },
}
