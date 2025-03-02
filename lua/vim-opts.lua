-- Vim tab options, indentation, and shift-width
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
-- Vim parser locations (to avoid errors in compilers)
vim.g.ruby_host_prog = "/home/evandagur/.rbenv/versions/3.3.0/bin/ruby"
vim.g.python3_host_prog = "/home/evandagur/.venvs/nvim/bin/python"
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/parsers")
vim.env.PATH = vim.env.PATH .. ":/usr/local/bin"
-- Vim key binds (map-leader and map-local-leader)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Lsps, and its configurations
vim.diagnostic.config({
	virtual_text = true,
	float = { source = "always" },
})
