local M = {}

function M.setup_lsp(on_attach)
    vim.lsp.config("clangd", { on_attach = on_attach })
    vim.lsp.enable("clangd")
end

function M.setup_clangd_extensions(opts)
    require("clangd_extensions").setup(opts)
    vim.lsp.inlay_hint.enable(true)

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function(ev)
            vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", {
                buffer = ev.buf,
                desc = "C/C++: Switch Source/Header",
            })
        end,
    })
end

return M
