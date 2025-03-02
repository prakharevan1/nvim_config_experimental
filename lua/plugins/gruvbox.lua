return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = ...,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				transparent_mode = true,
				inverse = true,
			})
			vim.o.background = "dark" -- or "light" for light mode
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
}
