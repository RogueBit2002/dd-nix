local vim = vim

vim.o.number = true;
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false

vim.o.termguicolors = true


vim.g.mapleader = " "

require("lualine").setup()
require("bufferline").setup({
	options = {
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				text_align = "center",
				separator = true
			}
		}
	}
})

vim.keymap.set('n', '<C+[>', ':BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<C+]>', ':BufferLineCycleNext<CR>', {})


vim.lsp.enable "lua_ls"
vim.lsp.enable "ts_ls"
vim.lsp.enable "zls"
vim.lsp.enable "nil_ls"
vim.lsp.enable "tofu_ls"

vim.o.completeopt = "preview,fuzzy,menuone,noinsert,noselect"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub('%b()', '') }
			end
		})

		vim.keymap.set('i', '<C-space>', vim.lsp.completion.get, { noremap = true })
	end
})

vim.diagnostic.enable = true
vim.diagnostic.config({
	virtual_lines = true,
	update_in_insert = true,
})

vim.o.winborder = "rounded"
vim.api.nvim_set_keymap("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', ":wincmd h<CR>")
vim.keymap.set('n', '<C-j>', ":wincmd j<CR>")
vim.keymap.set('n', '<C-k>', ":wincmd k<CR>")
vim.keymap.set('n', '<C-l>', ":wincmd l<CR>")

local telescope = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })

require("render-markdown").setup({})

vim.g.sonokai_better_performance = 1
vim.g.sonokai_enable_italic = true
vim.g.sonokai_transparent_background = 1

--[[
local c = require('vscode.colors').get_colors()
require('vscode').setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Enable italic inlay type hints
    italic_inlayhints = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Apply theme colors to terminal
    terminal_colors = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
vim.cmd.colorscheme "vscode"
]]

vim.cmd.colorscheme "sonokai"

