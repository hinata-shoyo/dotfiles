vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.shiftwidth = 3
vim.opt.tabstop = 3
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 11
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"

vim.opt.formatoptions:append({ "r" })

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>f", ":NvimTreeFindFile<Return>", opts)
keymap.set("n", "<Leader>t", ":NvimTreeToggle<Return>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nkzzzv", opts)

-- Diagnostics
-- keymap.set("n", "<C-j>", function()
-- 	vim.diagnostic.goto_next()
-- end, opts)

keymap.set("i", "kj", "<Esc>", {})
