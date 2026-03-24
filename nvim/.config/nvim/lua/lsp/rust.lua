local M = {}

function M.setup_lsp(on_attach)
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
end

return M
