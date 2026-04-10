local ts_opts = {
    ensure_installed = {
        "bash", "c", "cpp", "cmake", "json",
        "lua", "luadoc", "luap", "markdown", "markdown_inline",
        "python", "query", "regex", "rust", "ron", "toml",
        "vim", "vimdoc", "xml", "yaml",
    },
    highlight = { enable = true, disable = {} },
    indent = { enable = true, disable = {} },
    folds = { enable = false, disable = {} },
}

local textobjects_opts = {
    move = {
        enable = true,
        set_jumps = true,
        keys = {
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
    },
}

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind

        if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add({
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main",
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        version = "main",
    },
})

local TS = require("nvim-treesitter")
if not TS.get_installed then
    vim.notify(
        "nvim-treesitter: please update the plugin (`:lua vim.pack.update({ 'nvim-treesitter' })`)",
        vim.log.levels.WARNING
    )
    return
end

TS.setup(ts_opts)
local installed = TS.get_installed()
local missing = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
end, ts_opts.ensure_installed or {})

if #missing > 0 then
    TS.install(missing, { summary = true })
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
    callback = function(ev)
        local ft = ev.match
        local lang = vim.treesitter.language.get_lang(ft) or ft
        local ok_parser = pcall(vim.treesitter.language.inspect, lang)
        if not ok_parser then
            return
        end

        local function feat_enabled(feat_opts, current_lang)
            if type(feat_opts) ~= "table" then
                return false
            end
            if feat_opts.enable == false then
                return false
            end
            if type(feat_opts.disable) == "table" and vim.tbl_contains(feat_opts.disable, current_lang) then
                return false
            end
            return true
        end

        if feat_enabled(ts_opts.highlight, lang) then
            pcall(vim.treesitter.start, ev.buf)
        end

        if feat_enabled(ts_opts.indent, lang) then
            local current = vim.bo[ev.buf].indentexpr
            if current == "" or current == nil then
                vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        if feat_enabled(ts_opts.folds, lang) then
            local wo = vim.wo[0]
            if wo.foldmethod == "manual" then
                wo.foldmethod = "expr"
                wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end
        end
    end,
})

local TS_textobjects = require("nvim-treesitter-textobjects")
if not TS_textobjects.setup then
    vim.notify("nvim-treesitter-textobjects: please update the plugin", vim.log.levels.ERROR)
    return
end

TS_textobjects.setup(textobjects_opts)

local function attach(buf)
    local ft = vim.bo[buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local has_textobjects = pcall(vim.treesitter.query.get, lang, "textobjects")
    if not (vim.tbl_get(textobjects_opts, "move", "enable") and has_textobjects) then
        return
    end

    local moves = vim.tbl_get(textobjects_opts, "move", "keys") or {}
    for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
                local part = q:gsub("@", ""):gsub("%..*", "")
                part = part:sub(1, 1):upper() .. part:sub(2)
                table.insert(parts, part)
            end

            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")

            vim.keymap.set({ "n", "x", "o" }, key, function()
                if vim.wo.diff and key:find("[cC]") then
                    return vim.cmd("normal! " .. key)
                end
                require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, { buffer = buf, desc = desc, silent = true })
        end
    end
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user_treesitter_textobjects", { clear = true }),
    callback = function(ev)
        attach(ev.buf)
    end,
})

vim.tbl_map(attach, vim.api.nvim_list_bufs())
