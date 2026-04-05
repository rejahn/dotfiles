local M = {}

local modules = {
    "plugins.crates",
    "plugins.snacks",
    "plugins.completions",
    "plugins.git",
    "plugins.lsp-config",
    "plugins.treesitter",
    "plugins.mini",
    "plugins.clangd",
    "plugins.lualine",
    "plugins.bufferline",
    "plugins.none-ls",
    "plugins.poimandres",
    "plugins.tokyonight",
}

function M.setup()
    for _, module in ipairs(modules) do
        local ok, err = pcall(require, module)
        if not ok then
            vim.schedule(function()
                vim.notify(("Failed to load %s: %s"):format(module, err), vim.log.levels.ERROR)
            end)
        end
    end
end

return M
