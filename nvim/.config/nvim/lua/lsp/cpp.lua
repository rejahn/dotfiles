local M = {}

function M.setup_lsp(on_attach, capabilities)
    vim.lsp.config("clangd", {
        on_attach = function(client, bufnr)
            if on_attach then
                on_attach(client, bufnr)
            end

            vim.keymap.set("n", "<leader>ch", function()
                require("clangd_extensions.switch_source_header").switch_source_header()
            end, {
                buffer = bufnr,
                desc = "C/C++: Switch Source/Header",
            })
        end,
        capabilities = capabilities,
        cmd = { vim.fn.exepath("clangd") ~= "" and vim.fn.exepath("clangd") or "clangd" },
    })
    vim.lsp.enable("clangd")
end

function M.setup_clangd_extensions(opts)
    require("clangd_extensions").setup(opts)
    vim.lsp.inlay_hint.enable(true)
end

return M
