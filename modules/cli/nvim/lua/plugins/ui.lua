return {
	{
		name = "tokyonight.nvim",
		dir = "@tokyonight_nvim@",
		lazy = false,
		event = "VeryLazy",
		dependencies = {
			{ name = "nvim-web-devicons", dir = "@nvim_web_devicons@" },
			{ name = "lualine.nvim", dir = "@lualine_nvim@" },
		},
		priority = 1000,
		opts = {
			style = "moon",
			transparent = true,
			tokyonight_dark_float = false,
			terminal_colors = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function()
			-- theme
			vim.cmd([[colorscheme tokyonight-night]])
			vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])

			-- lualine
			require("tokyonight.colors")
			require("lualine").setup({
				options = {
					icons_enable = true,
					globalstatus = true,
					theme = "tokyonight",
					tabline = {},
				},
			})
		end,
	},
	{
		name = "noice.nvim",
		dir = "@noice_nvim@",
		event = "VeryLazy",
		dependencies = {
			{ name = "nui.nvim", dir = "@nui_nvim@" },
			{ name = "nvim-notify", dir = "@nvim_notify@" },
		},
		config = function()
			require("noice").setup({
				presents = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
				views = {
					cmdline_popup = {
						position = {
							row = 10,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
			})
		end,
	},

	{
		name = "nvim-colorizer.lua",
		dir = "@nvim_colorizer_lua@",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup()
		end,
	},
}
