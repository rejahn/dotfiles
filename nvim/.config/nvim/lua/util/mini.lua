---@class user.util.mini
local M = {}

-- taken from MiniExtra.gen_ai_spec.buffer
function M.ai_buffer(ai_type)
    local start_line, end_line = 1, vim.fn.line("$")
    if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
    end

    local to_col = math.max(vim.fn.getline(end_line):len(), 1)
    return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

-- register all text objects with which-key
---@param opts table
function M.ai_whichkey(opts)
    local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
    }

    ---@type wk.Spec[]
    local ret = { mode = { "o", "x" } }
    ---@type table<string, string>
    local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
    }, opts.mappings or {})
    mappings.goto_left = nil
    mappings.goto_right = nil

    for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
            local desc = obj.desc
            if prefix:sub(1, 1) == "i" then
                desc = desc:gsub(" with ws", "")
            end
            ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
    end
    require("which-key").add(ret, { notify = false })
end

---@param opts {modes: table, skip_next: string, skip_ts: string[], skip_unbalanced: boolean, markdown: boolean}
function M.pairs(opts)
    local pairs = require("mini.pairs")

    pairs.setup({
        modes = opts.modes,
    })

    local open = pairs.open

    pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
            return open(pair, neigh_pattern)
        end

        local o = pair:sub(1, 1)
        local c = pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local col = cursor[2]

        local next_char = line:sub(col + 1, col + 1)
        local before = line:sub(1, col)
        local after = line:sub(col + 1)

        if opts.skip_next and next_char ~= "" and next_char:match(opts.skip_next) then
            return o
        end

        if opts.skip_ts and #opts.skip_ts > 0 then
            local ok, node = pcall(vim.treesitter.get_node)
            if ok and node then
                while node do
                    if vim.tbl_contains(opts.skip_ts, node:type()) then
                        return o
                    end
                    node = node:parent()
                end
            end
        end

        if opts.skip_unbalanced and next_char == c then
            local opens = select(2, before:gsub(vim.pesc(o), ""))
            local closes = select(2, after:gsub(vim.pesc(c), ""))
            if closes > opens then
                return o
            end
        end

        if opts.markdown and o == "`" and c == "`" then
            local ft = vim.bo.filetype
            if ft == "markdown" or ft == "mdx" then
                local prev_3 = line:sub(math.max(1, col - 1), col + 1)
                local next_3 = line:sub(col + 1, col + 3)
                if prev_3 == "```" or next_3 == "```" then
                    return o
                end
            end
        end

        return open(pair, neigh_pattern)
    end
end

---@param opts {mappings: table}
---@param keys table|nil
function M.surround_keys(opts, keys)
    local mappings = {
        { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "x" } },
        { opts.mappings.delete, desc = "Delete Surrounding" },
        { opts.mappings.find, desc = "Find Right Surrounding" },
        { opts.mappings.find_left, desc = "Find Left Surrounding" },
        { opts.mappings.highlight, desc = "Highlight Surrounding" },
        { opts.mappings.replace, desc = "Replace Surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    }

    mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
    end, mappings)

    return vim.list_extend(mappings, keys or {})
end

return M
