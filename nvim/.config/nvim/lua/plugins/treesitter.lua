return {

    -- Core treesitter: highlighting, indentation, folding
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile", "VeryLazy" },
        cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "bash", "c", "cpp", "cmake", "diff", "html", "json",
                "lua", "luadoc", "luap", "markdown", "markdown_inline", "printf",
                "python", "query", "regex", "rust", "ron", "toml",
                "vim", "vimdoc", "xml", "yaml",
            },

            highlight        = { enable = true, disable = {} },
            indent           = { enable = true, disable = {} },
            folds            = { enable = false, disable = {} },
        },

        config = function(_, opts)
            local TS = require("nvim-treesitter")

            if not TS.get_installed then
                vim.notify(
                    "nvim-treesitter: please update the plugin (`:Lazy update nvim-treesitter`)",
                    vim.log.levels.WARNING
                )
                return
            end

            -- Install missing parsers on startup
            TS.setup(opts)
            local installed = TS.get_installed() -- returns list of installed lang strings

            local missing = vim.tbl_filter(function(lang)
                return not vim.tbl_contains(installed, lang)
            end, opts.ensure_installed or {})

            if #missing > 0 then
                TS.install(missing, { summary = true })
            end

            -- Per-filetype: attach highlighting, indentation, folding
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
                callback = function(ev)
                    local ft        = ev.match
                    local lang      = vim.treesitter.language.get_lang(ft) or ft

                    -- Check a parser is actually available before doing anything
                    local ok_parser = pcall(vim.treesitter.language.inspect, lang)
                    if not ok_parser then return end

                    local function feat_enabled(feat_opts, l)
                        if type(feat_opts) ~= "table" then return false end
                        if feat_opts.enable == false then return false end
                        if type(feat_opts.disable) == "table"
                            and vim.tbl_contains(feat_opts.disable, l) then
                            return false
                        end
                        return true
                    end

                    -- Highlighting
                    if feat_enabled(opts.highlight, lang) then
                        pcall(vim.treesitter.start, ev.buf)
                    end

                    -- Indentation (set only if not already customised by another plugin)
                    if feat_enabled(opts.indent, lang) then
                        local current = vim.bo[ev.buf].indentexpr
                        if current == "" or current == nil then
                            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                        end
                    end

                    -- Folding (set only when foldmethod hasn't been touched)
                    if feat_enabled(opts.folds, lang) then
                        local wo = vim.wo[0]  -- window-local for current window
                        if wo.foldmethod == "manual" then -- default; hasn't been set
                            wo.foldmethod = "expr"
                            wo.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
                        end
                    end
                end,
            })
        end,
    },

    -- Textobjects: navigate functions, classes, parameters with ]f [f etc.
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        opts = {
            move = {
                enable = true,
                set_jumps = true,
                keys = {
                    goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
                    goto_next_end       = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
                    goto_previous_end   = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
                },
            },
        },

        config = function(_, opts)
            local TS = require("nvim-treesitter-textobjects")
            if not TS.setup then
                vim.notify("nvim-treesitter-textobjects: please update the plugin", vim.log.levels.ERROR)
                return
            end
            TS.setup(opts)

            -- Attach buffer-local keymaps when a supported filetype loads
            local function attach(buf)
                local ft = vim.bo[buf].filetype
                -- Check textobjects query file exists for this ft
                local lang = vim.treesitter.language.get_lang(ft) or ft
                local has_textobjects = pcall(vim.treesitter.query.get, lang, "textobjects")
                if not (vim.tbl_get(opts, "move", "enable") and has_textobjects) then
                    return
                end

                local moves = vim.tbl_get(opts, "move", "keys") or {}
                for method, keymaps in pairs(moves) do
                    for key, query in pairs(keymaps) do
                        local queries = type(query) == "table" and query or { query }

                        -- Build a human-readable description from the query string
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
                            -- In diff mode, let c/C pass through to native diff navigation
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
                callback = function(ev) attach(ev.buf) end,
            })
            -- Attach to any buffers already open when this loads
            vim.tbl_map(attach, vim.api.nvim_list_bufs())
        end,
    },
}
