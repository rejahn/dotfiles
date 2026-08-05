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

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/nvim-mini/mini.nvim",
})

local ai = require("mini.ai")
local diff = require("mini.diff")
local tabline = require("mini.tabline")
local pairs = require("mini.pairs")
local surround = require("mini.surround")
local move = require("mini.move")
local basics = require("mini.basics")
local notify = require("mini.notify")
local hipatterns = require("mini.hipatterns")

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

diff.setup({
	view = {
		style = "sign",
		signs = {
			add = "▎",
			change = "▎",
			delete = "▎",
		},
	},
	mappings = {
		apply = "gh",
		reset = "gH",
		textobject = "gh",
		goto_first = "[H",
		goto_prev = "[h",
		goto_next = "]h",
		goto_last = "]H",
	},
})

vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "MiniDiffOverChange", { link = "DiffDelete" })
vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { link = "DiffAdd" })
vim.api.nvim_set_hl(0, "MiniDiffOverContext", { link = "DiffChange" })
vim.api.nvim_set_hl(0, "MiniDiffOverContextBuf", { link = "DiffChange" })

tabline.setup({
	show_icons = false,
	tabpage_section = "right",
	show_single_tab = false,
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
vim.keymap.set("n", "<leader>gho", diff.toggle_overlay, { silent = true, desc = "Toggle Git Diff Overlay" })

move.setup()
basics.setup()
notify.setup()

hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
	},
})
