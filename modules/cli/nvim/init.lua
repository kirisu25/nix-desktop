vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.pumblend = 5
vim.opt.winblend = 5
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmode = "longest:full,full"
vim.opt.hidden = true
vim.opt.wrap = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.matchtime = 1

-- status line
vim.opt.cmdheight = 0
vim.opt.laststatus = 2

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wildmenu = true
-- vim.opt.list = true
-- vim.opt.listchars:append("space:|")
vim.opt.completeopt = "menu,menuone,noselect"

-- keymap
vim.keymap.set("i", "jj", "<ESC>", { noremap = true })
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "<LEADER>w", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<LEADER>q", ":q<CR>", { noremap = true })
vim.keymap.set("n", "<LEADER>a", "gg<S-v>G", { noremap = true })
vim.keymap.set("n", "<ESC><ESC>", ":nohlsearch<CR><ESC>")

-- terminal
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { noremap = true })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { noremap = true })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { noremap = true })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { noremap = true })
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { noremap = true })
vim.cmd("autocmd TermOpen * :startinsert")
vim.cmd("autocmd TermOpen * setlocal norelativenumber")
vim.cmd("autocmd TermOpen * setlocal nonumber")

local function float_term(cmd)
	local opts = { size = { width = 0.9, height = 0.9 } }
	require("lazy.util").float_term(cmd, opts)
end
vim.keymap.set("n", "<LEADER>gg", function()
	float_term({ "lazygit" })
end)

local lazypath = "@lazy_nvim@"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	defaults = { lazy = true },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	spec = "plugins",
})