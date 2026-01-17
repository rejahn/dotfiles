return {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 10001,
    config = function()
        require('poimandres').setup {}
    end,

    init = function()
        -- vim.cmd("colorscheme poimandres")
    end
}
