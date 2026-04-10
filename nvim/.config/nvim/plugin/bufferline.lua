local opts = {

    options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        always_show_bufferline = false,
        diagnostics = false,
        mode = "buffers",
        separator_style = { "", "" },
        numbers = "none",
        color_icons = false,

        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        indicator = {
            style = "none",
        },
        modified_icon = "+",
        buffer_close_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 32,
        max_prefix_length = 12,
        truncate_names = true,
        offsets = {
            {
                filetype = "neo-tree",
                text = "files",
                highlight = "Directory",
                text_align = "left",
            },
            {
                filetype = "snacks_layout_box",
            },
        },
    },
}

vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",
    {
        src = "https://github.com/akinsho/bufferline.nvim",
        version = vim.version.range("4.x"),
    },
})

local bufferline = require("bufferline")
opts.options.style_preset = {
    bufferline.style_preset.minimal,
    bufferline.style_preset.no_italic,
    bufferline.style_preset.no_bold,
}

bufferline.setup(opts)
vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bold = false, italic = false })
vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "NONE", bg = "NONE" })
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
    callback = function()
        vim.schedule(function()
            pcall(nvim_bufferline)
        end)
    end,
})

local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<leader>bp", "<Cmd>BufferLineTogglePin<CR>", "Toggle Pin")
map("<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete Non-Pinned Buffers")
map("<leader>br", "<Cmd>BufferLineCloseRight<CR>", "Delete Buffers to the Right")
map("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", "Delete Buffers to the Left")
map("<leader>bj", "<Cmd>BufferLinePick<CR>", "Pick Buffer")
map("<S-h>", "<Cmd>BufferLineCyclePrev<CR>", "Prev Buffer")
map("<S-l>", "<Cmd>BufferLineCycleNext<CR>", "Next Buffer")
-- map("[b", "<Cmd>BufferLineCyclePrev<CR>", "Prev Buffer")
-- map("]b", "<Cmd>BufferLineCycleNext<CR>", "Next Buffer")
map("[B", "<Cmd>BufferLineMovePrev<CR>", "Move Buffer Prev")
map("]B", "<Cmd>BufferLineMoveNext<CR>", "Move Buffer Next")
