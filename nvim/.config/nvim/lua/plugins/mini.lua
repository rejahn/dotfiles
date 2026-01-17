return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        -- Core mini modules
        local ai = require('mini.ai')
        ai.setup({
            custom_textobjects = {
                f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
                c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
                o = ai.gen_spec.treesitter({
                    a = { '@conditional.outer', '@loop.outer' },
                    i = { '@conditional.inner', '@loop.inner' },
                }),
            },
        })
        --
        require("mini.pairs").setup()
        require("mini.surround").setup()
    end,
}
