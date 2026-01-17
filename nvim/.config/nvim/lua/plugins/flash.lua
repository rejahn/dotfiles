return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
        { "gw", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
        { "gW", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
}
