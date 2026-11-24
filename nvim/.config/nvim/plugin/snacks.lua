vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

local opts = {
	statuscolumn = {
		enabled = true,
		left = { "sign" },
		right = { "git" },
	},
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	explorer = { enabled = true },
	picker = {
		enabled = true,
		prompt = "",
		sources = {
			files = {
				exclude = {
					".git",
					".git/**",
					".DS_Store",
					".venv",
					".venv/**",
					"node_modules",
					"node_modules/**",
					".cache",
					".cache/**",
					"dist",
					"dist/**",
					"build",
					"build/**",
					"target",
					"target/**",
					"__pycache__",
					"__pycache__/**",
				},
			},
			explorer = {
				hidden = true,
			},
		},
		icons = {
			files = { enabled = true },
		},
	},
	lazygit = { enabled = true },
	indent = {
		enabled = true,
		animate = { enabled = false },
		indent = { char = "┊" },
		scope = { enabled = false },
		input = true,
	},
}

local Snacks = require("snacks")
Snacks.setup(opts)

Snacks.toggle.new({
	name = "Autoformat (global)",
	get = function()
		return not vim.g.disable_autoformat
	end,
	set = function(state)
		vim.g.disable_autoformat = not state
	end,
}):map("<leader>tf")

require("keymaps").snacks(Snacks)
