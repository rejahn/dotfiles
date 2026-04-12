local mini_util = require("util.mini")

local surround_opts = {
  mappings = {
    add = "gsa",                -- Add surrounding in Normal and Visual modes
    delete = "gsd",             -- Delete surrounding
    find = "gsf",               -- Find surrounding (to the right)
    find_left = "gsF",          -- Find surrounding (to the left)
    highlight = "gsh",          -- Highlight surrounding
    replace = "gsr",            -- Replace surrounding
    update_n_lines = "gsn",     -- Update `n_lines`
  },
}

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-mini/mini.nvim",
})

local ai = require("mini.ai")
local tabline = require("mini.tabline")
local pairs = require("mini.pairs")
local surround = require("mini.surround")

ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    d = { "%f[%d]%d+" },
    e = {
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    g = ai.buffer,
    u = ai.gen_spec.function_call(),
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
  },
})

tabline.setup({
  show_icons = false,
  tabpage_section = "right",
})

pairs.setup(mini_util.pairs({
  modes = { insert = true, command = true, terminal = false },
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  skip_ts = { "string" },
  skip_unbalanced = true,
  markdown = true,
}))

surround.setup(surround_opts)

vim.keymap.set("n", "<S-h>", "<Cmd>bprevious<CR>", { silent = true, desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", { silent = true, desc = "Next Buffer" })