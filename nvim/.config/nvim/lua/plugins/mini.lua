return {
    "nvim-mini/mini.nvim",
    version = false,
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
        -- Core mini modules
        local ai = require('mini.ai')
        ai.setup({
            n_lines = 500,
            custom_textobjects = {
                o = ai.gen_spec.treesitter({ -- code block
                    a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                    i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                }),
                f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
                c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
                t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
                d = { "%f[%d]%d+" },                                                          -- digits
                e = {                                                                         -- Word with case
                    { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
                    "^().*()$",
                },
                g = ai.buffer,                                             -- buffer
                u = ai.gen_spec.function_call(),                           -- u for "Usage"
                U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
            },
        })
        --
        local pairs = require("mini.pairs")

        local opts = {
            modes = { insert = true, command = true, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { "string" },
            skip_unbalanced = true,
            markdown = true,
        }

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
    end,
}
