local mini_util = require("util.mini")

local surround_opts = {
    mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
    },
}

return {
    {
        "nvim-mini/mini.nvim",
        version = false,
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            -- Core mini modules
            local ai = require("mini.ai")
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

            mini_util.pairs({
                modes = { insert = true, command = true, terminal = false },
                skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
                skip_ts = { "string" },
                skip_unbalanced = true,
                markdown = true,
            })
        end,
    },
    {
        "nvim-mini/mini.surround",
        keys = function(_, keys)
            return mini_util.surround_keys(surround_opts, keys)
        end,
        opts = surround_opts,
    },
}
