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
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/folke/snacks.nvim",
})

require("which-key").setup({
	preset = "helix",
})

local Snacks = require("snacks")
Snacks.setup(opts)

local map = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
end

map("<leader>f", function()
	Snacks.picker.files()
end, "Find files")
map("<leader>,", function()
	Snacks.picker.buffers()
end, "Buffers")
map("<leader>j", function()
	Snacks.picker.jumps()
end, "Jumplist")
map("<leader>gb", function()
	Snacks.picker.git_branches()
end, "Git Branches")
map("<leader>gl", function()
	Snacks.picker.git_log()
end, "Git Log")
map("<leader>gL", function()
	Snacks.picker.git_log_file()
end, "Git Log Line")
map("<leader>gs", function()
	Snacks.picker.git_status()
end, "Git Status")
map("<leader>gS", function()
	Snacks.picker.git_stash()
end, "Git Stash")
map("<leader>gd", function()
	Snacks.picker.git_diff()
end, "Git Diff (Hunks)")
map("<leader>gB", function()
	Snacks.git.blame_line()
end, "Git Blame Line")
map("<leader>gf", function()
	Snacks.picker.git_log_file()
end, "Git Log File")
map("<leader>lg", function()
	Snacks.lazygit()
end, "Lazygit")
map("<leader>:", function()
	Snacks.picker.command_history()
end, "Command History")
map("<leader>'", function()
	Snacks.picker.resume()
end, "Resume picker")
map("<leader>/", function()
	Snacks.picker.grep()
end, "Live grep")
map("<leader>?", function()
	Snacks.picker.commands()
end, "Commands")
map("<leader><leader>", function()
	Snacks.picker.recent()
end, "Recent files")
map("<leader>H", function()
	Snacks.picker.help()
end, "Help tags")
map("<leader>d", function()
	Snacks.picker.diagnostics_buffer()
end, "Document diagnostics")
map("<leader>D", function()
	Snacks.picker.diagnostics()
end, "Workspace diagnostics")
map("<leader>s", function()
	Snacks.picker.lsp_symbols()
end, "Document symbols")
map("<leader>S", function()
	Snacks.picker.lsp_workspace_symbols()
end, "LSP Workspace Symbols")
map("gd", function()
	Snacks.picker.lsp_definitions()
end, "Goto Definition")
map("gD", function()
	Snacks.picker.lsp_declarations()
end, "Goto Declaration")
map("gr", function()
	Snacks.picker.lsp_references()
end, "References")
map("gI", function()
	Snacks.picker.lsp_implementations()
end, "Goto Implementation")
map("gy", function()
	Snacks.picker.lsp_type_definitions()
end, "Goto Type Definition")
map("gai", function()
	Snacks.picker.lsp_incoming_calls()
end, "Incoming Calls")
map("gao", function()
	Snacks.picker.lsp_outgoing_calls()
end, "Outgoing Calls")
map("<leader>e", function()
	Snacks.explorer({ layout = { layout = { position = "right" } } })
end, "Explorer")
map("<leader>th", function()
	Snacks.toggle.inlay_hints():toggle()
end, "Toggle Inlay Hints")
