local M = {}

function M.setup_lsp(on_attach, capabilities)
    vim.lsp.config("rust_analyzer", {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { vim.fn.exepath("rust-analyzer") ~= "" and vim.fn.exepath("rust-analyzer") or "rust-analyzer" },
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(
                vim.fs.root(fname, { "Cargo.toml" })
                    or vim.fs.root(fname, { "rust-project.json", ".git" })
                    or vim.fs.dirname(fname)
            )
        end,
        settings = {
            ["rust-analyzer"] = {
                cargo = { features = "all" },
                check = { command = "clippy" },
            },
        },
    })
    vim.lsp.enable("rust_analyzer")
end

return M
