return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",

  opts = {
    options = {
      close_command       = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,

      diagnostics = "nvim_lsp",
      always_show_bufferline = false,

      -- diagnostics_indicator = function(_, _, diag)
        -- ⚠ LazyVim.config.icons.diagnostics replaced with hardcoded icons.
        -- In LazyVim these come from your icons config (usually in config/options.lua).
        -- Set these to match whatever icons you use elsewhere in your config.
        -- local icons = {
          -- Error = " ",
          -- Warn  = " ",
        -- }
        -- local ret = (diag.error   and icons.Error .. diag.error   .. " " or "")
                 -- .. (diag.warning and icons.Warn  .. diag.warning       or "")
        -- return vim.trim(ret)
      -- end,

      offsets = {
        {
          filetype   = "neo-tree",
          text       = "Neo-tree",
          highlight  = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
      get_element_icon = function(opts)
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if ok then
          local icon, hl = devicons.get_icon_by_filetype(opts.filetype, { default = true })
          return icon, hl
        end
      end,
    },
  },

  config = function(_, opts)
    require("bufferline").setup(opts)
    vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { italic = false })
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

    map("<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            "Toggle Pin")
    map("<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete Non-Pinned Buffers")
    map("<leader>br", "<Cmd>BufferLineCloseRight<CR>",           "Delete Buffers to the Right")
    map("<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            "Delete Buffers to the Left")
    map("<leader>bj", "<Cmd>BufferLinePick<CR>",                 "Pick Buffer")
    map("<S-h>",      "<Cmd>BufferLineCyclePrev<CR>",            "Prev Buffer")
    map("<S-l>",      "<Cmd>BufferLineCycleNext<CR>",            "Next Buffer")
    map("[b",         "<Cmd>BufferLineCyclePrev<CR>",            "Prev Buffer")
    map("]b",         "<Cmd>BufferLineCycleNext<CR>",            "Next Buffer")
    map("[B",         "<Cmd>BufferLineMovePrev<CR>",             "Move Buffer Prev")
    map("]B",         "<Cmd>BufferLineMoveNext<CR>",             "Move Buffer Next")
  end,
}
