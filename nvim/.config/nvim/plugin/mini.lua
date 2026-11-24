vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/nvim-mini/mini.nvim",
})

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

local ai = require("mini.ai")
local diff = require("mini.diff")
local git = require("mini.git")
local pairs = require("mini.pairs")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local move = require("mini.move")
local basics = require("mini.basics")
local notify = require("mini.notify")
local hipatterns = require("mini.hipatterns")
local icons = require("mini.icons")

icons.setup()
icons.mock_nvim_web_devicons()

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
		g = mini_util.ai_buffer,
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
		apply = "",
		reset = "",
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

pairs.setup(mini_util.pairs({
	modes = { insert = true, command = true, terminal = false },
	skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
	skip_ts = { "string" },
	skip_unbalanced = true,
	markdown = true,
}))

surround.setup(surround_opts)
splitjoin.setup({ mappings = { toggle = "gS" } })
git.setup()

vim.keymap.set("n", "<leader>gr", function()
	return diff.operator("reset") .. "gh"
end, { expr = true, remap = true, desc = "Restore hunk" })
vim.keymap.set("n", "<leader>gR", function()
	return diff.operator("reset") .. "_"
end, { expr = true, desc = "Restore line" })
vim.keymap.set("n", "<leader>ga", function()
	return diff.operator("apply") .. "gh"
end, { expr = true, remap = true, desc = "Apply (stage) hunk" })
vim.keymap.set("n", "<leader>gy", function()
	return diff.operator("yank") .. "gh"
end, { expr = true, remap = true, desc = "Yank original hunk" })
vim.keymap.set("n", "<leader>gd", diff.toggle_overlay, { silent = true, desc = "Toggle Git Diff Overlay" })
vim.keymap.set("n", "<leader>gb", "<cmd>vertical Git blame -- %<cr>", { silent = true, desc = "Git Blame File" })
vim.keymap.set({ "n", "x" }, "<leader>gh", "<cmd>lua MiniGit.show_at_cursor()<cr>", {
	silent = true,
	desc = "Git History at Cursor",
})

move.setup()
basics.setup()
notify.setup()
local input = require("mini.input")
input.setup({
	scope = "editor",
	handlers = {
		view = input.gen_view.floatwin({ style = "BM" }),
	},
})

hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		url = { pattern = [=[%f[%w]https?://[^%s<>"'`]+]=], group = "Underlined" },
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
	},
})

-- Reuse the existing session directory so previous workspaces remain available.
require("mini.sessions").setup({
	directory = vim.fn.stdpath("state") .. "/sessions",
	file = "",
	autoread = false,
	autowrite = true,
	verbose = { read = false, write = false, delete = true },
})
require("keymaps").sessions()

local clue = require("mini.clue")
clue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<leader>" },
		{ mode = { "n", "x" }, keys = "g" },
		{ mode = { "n", "x" }, keys = "z" },
		{ mode = "n", keys = "<C-w>" },
	},
	window = { delay = 300 },
	clues = {
		require("keymaps").clues,
		clue.gen_clues.g(),
		clue.gen_clues.z(),
		clue.gen_clues.windows(),
	},
})
