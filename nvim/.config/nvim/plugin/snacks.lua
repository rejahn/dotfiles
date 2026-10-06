local opts = {
	bigfile = { enabled = true },
	git = { enabled = true },
	input = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = false },
	words = { enabled = false },
	rename = { enabled = true },
	toggle = { enabled = true },
	lazygit = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			files = {
				layout = { preset = "default" },
				hidden = true,
				ignored = true,
				follow = false,
				exclude = {
					".git/",
					".venv/",
					"node_modules/",
					".cache/",
					"build/",
					"dist/",
					"target/",
					"__pycache__/",
				},
			},
			explorer = {
				hidden = true,
			},
			grep = {
				layout = { preset = "default" },
				hidden = true,
				ignored = false,
				exclude = {
					".git/",
					"node_modules/",
					".cache/",
					"build/",
					"dist/",
					"target/",
				},
			},
		},
	},
	indent = {
		enabled = true,
		animate = {
			enabled = false,
		},
		indent = {
			char = "┊",
		},
		scope = {
			enabled = false,
		},
	},
}

vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

local Snacks = require("snacks")
Snacks.setup(opts)

require("keymaps").snacks()
