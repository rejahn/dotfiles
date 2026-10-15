local opts = {
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	explorer = { enabled = true },
	picker = {
		enabled = true,
		prompt = "",
		sources = {
			files = {
				hidden = true,
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
			files = { enabled = false },
		},
	},
	lazygit = { enabled = true },
	indent = {
		enabled = true,
		animate = { enabled = false },
		indent = { char = "┊" },
		scope = { enabled = false },
	},
}

vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

local Snacks = require("snacks")
Snacks.setup(opts)

require("keymaps").snacks(Snacks)
