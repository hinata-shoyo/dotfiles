vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- vim.cmd([[
--   let g:ale_linters = {
--       \ 'typescript': ['ts_ls'],
--       \ 'typescriptreact': ['ts_ls'],
--       \ }
--   let g:ale_fixers = {
--       \ 'typescript': ['prettier'],
--       \ 'typescriptreact': ['prettier'],
--       \ }
--   let g:ale_fix_on_save = 1
-- ]])

require("lazy").setup({ { import = "mafuyu.plugins" }, { import = "mafuyu.plugins.lsp" } }, {
	change_detection = {
		notify = false,
	},
})
require("options")
require("telescope").setup({ defaults = { file_ignore_patterns = { "node_modules" } } })
