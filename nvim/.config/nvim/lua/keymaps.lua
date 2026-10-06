local M = {}

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Focus window above" })
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Focus window below" })
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Focus window left" })
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Focus window right" })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- map for quick quit, save files using leader key
vim.keymap.set("n", "<Leader>w", ":write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Leader>x", ":wq<CR>", { desc = "Save and quit" })

-- code actions
vim.keymap.set("n", "<leader>ca", function()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.lsp.buf.code_action({
		range = {
			start = { row, 0 },
			["end"] = { row, #vim.api.nvim_get_current_line() },
		},
	})
end, { desc = "Code actions", silent = true })

-- improve indentation
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- centered cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

-- Prefix labels for mini.clue; actual bindings supply their own descriptions.
M.clues = {
	{ mode = "n", keys = "<leader>b", desc = "Buffers" },
	{ mode = "n", keys = "<leader>c", desc = "Code" },
	{ mode = { "n", "x" }, keys = "<leader>g", desc = "Git" },
	{ mode = "n", keys = "<leader>q", desc = "Sessions" },
	{ mode = "n", keys = "<leader>s", desc = "Search" },
	{ mode = "n", keys = "<leader>t", desc = "Toggles" },
}

-- Pickers, explorer, Git, and toggles
function M.snacks()
	local Snacks = require("snacks")
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
	map("<leader>lg", function()
		Snacks.lazygit()
	end, "Lazygit")
	map("<leader>s:", function()
		Snacks.picker.command_history()
	end, "Command History")
	map("<leader>/", function()
		Snacks.picker.grep()
	end, "Live grep")
	map("<leader>sc", function()
		Snacks.picker.commands()
	end, "Commands")
	map("<leader>?", function()
		Snacks.picker.help()
	end, "Help tags")
	map("<leader>d", function()
		Snacks.picker.diagnostics_buffer()
	end, "Document diagnostics")
	map("<leader>D", function()
		Snacks.picker.diagnostics()
	end, "Workspace diagnostics")
	map("<leader>cs", function()
		Snacks.picker.lsp_symbols()
	end, "Document symbols")
	map("<leader>cS", function()
		Snacks.picker.lsp_workspace_symbols()
	end, "LSP Workspace Symbols")
	map("gd", function()
		Snacks.picker.lsp_definitions()
	end, "Goto Definition")
	map("gD", function()
		Snacks.picker.lsp_declarations()
	end, "Goto Declaration")
	map("grr", function()
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
	map("<leader>td", function()
		Snacks.toggle.diagnostics():toggle()
	end, "Toggle Diagnostics")
	map("<leader>te", function()
		Snacks.terminal()
	end, "Toggle Terminal")
end

-- Bufferline
function M.bufferline()
	vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
	vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

	vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
	vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
end

-- Named workspace sessions
function M.sessions()
	vim.keymap.set("n", "<leader>qs", function()
		vim.ui.input({ prompt = "Save session as: ", default = vim.fs.basename(vim.fn.getcwd()) }, function(name)
			if name == nil or vim.trim(name) == "" then
				return
			end
			require("mini.sessions").write(vim.trim(name))
		end)
	end, { desc = "Save Session" })

	vim.keymap.set("n", "<leader>qS", function()
		require("mini.sessions").select()
	end, { desc = "Select Session" })

	vim.keymap.set("n", "<leader>ql", function()
		local sessions = require("mini.sessions")
		local latest = sessions.get_latest()
		if latest then
			sessions.read(latest)
		else
			vim.notify("No saved sessions", vim.log.levels.INFO)
		end
	end, { desc = "Restore Last Session" })

	vim.keymap.set("n", "<leader>qd", function()
		vim.v.this_session = ""
	end, { desc = "Stop Session Saving" })
end

-- Buffer-local LSP bindings
function M.lsp_attach(client, bufnr)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })

	if client.name == "clangd" then
		vim.keymap.set("n", "<leader>ch", function()
			require("clangd_extensions.switch_source_header").switch_source_header()
		end, { buffer = bufnr, desc = "C/C++: Switch Source/Header" })
	end
end

-- Completion preset
M.completion = { preset = "enter" }

return M
