return {
	{
		name = "neo-tree.nvim",
		dir = "@neo_tree_nvim@",
		dependencies = {
			{ name = "nui.nvim", dir = "@nui_nvim@" },
			{ name = "nvim-web-devicons", dir = "@nvim_web_devicons@" },
			{ name = "plenary.nvim", dir = "@plenary_nvim@" },
		},
		cmd = { "Neotree" },
		init = function()
			vim.g.neo_tree_remove_lagacy_commands = 1
			vim.keymap.set("n", "<LEADER>e", ":Neotree toggle<CR>", { desc = "Neotree" })
		end,
		config = true,
	},
	{
		name = "nvim-autopairs",
		dir = "@nvim_autopairs@",
		event = "InsertEnter",
		config = true,
	},
	{
		name = "trouble.nvim",
		dir = "@trouble_nvim@",
		config = true,
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		},
	},
	{
		name = "telescope.nvim",
		dir = "@telescope_nvim@",
		dependencies = {
			{ name = "plenary.nvim", dir = "@plenary_nvim@" },
			{ name = "trouble.nvim", dir = "@trouble_nvim@" },
		},
		cmd = "Telescope",
		keys = { "<LEADER>f", "<LEADER>h" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local open_with_trouble = require("trouble.sources.telescope").open
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")
			local helpTags = function()
				builtin.help_tags(themes.get_ivy())
			end

			vim.keymap.set("n", "<LEADER>ff", builtin.find_files, { desc = "find files" })
			vim.keymap.set("n", "<LEADER>fg", builtin.live_grep, { desc = "live grep" })
			vim.keymap.set("n", "<LEADER>fb", builtin.buffers, { desc = "find buffers" })
			vim.keymap.set("n", "<LEADER>fh", helpTags, { desc = "Help tags" })

			telescope.setup({
				defaults = {
					mappings = {
						i = { ["<C-t>"] = open_with_trouble },
						n = { ["<C-t>"] = open_with_trouble },
					},
				},
			})
		end,
	},
	{
		name = "nvim-treesitter",
		dir = "@nvim_treesitter@",
		event = "BufRead",
		config = function()
			vim.opt.runtimepath:append("@ts_parser_dirs@")
		end,
	},
	{
		name = "toggleterm.nvim",
		dir = "@toggleterm_nvim@",
		keys = { "<c-/>", "<LEADER><C-/>" },
		config = function()
			require("toggleterm").setup({
				close_on_exit = true,
				direction = "float",
				insert_mappings = true,
				open_mapping = [[<c-/>]],
				persist_size = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				size = 100,
				start_in_insert = true,
			})
		end,

		vim.keymap.set("n", "<LEADER><c-/>", ":ToggleTerm size=30 direction=horizontal<CR>"),
	},
	{
		name = "remote-nvim.nvim",
		dir = "@remote_nvim_nvim@",
		event = "CmdlineEnter",
		dependencies = {
			{ name = "telescope.nvim", dir = "@telescope_nvim@" },
			{ name = "plenary.nvim", dir = "@plenary_nvim@" },
			{ name = "nui.nvim", dir = "@nui_nvim@" },
		},
		config = true,
	},
	{
		name = "iron.nvim",
		dir = "@iron_nvim@",
		ft = { "python" },
		config = function()
			local core = require("iron.core")
			local view = require("iron.view")
			local marks = require("iron.marks")
			local common = require("iron.fts.common")
			local visual_send_and_move_down = function()
				core.visual_send()
				vim.cmd("normal! j")
			end
			local line_send_and_move_down = function()
				core.send_line()
				vim.cmd("normal! j")
			end

			core.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						sh = {
							command = { "zsh" },
						},
						python = {
							command = { "ipython", "--no-autoindent" },
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
						},
					},
					repl_filetype = function(bufnr, ft)
						return ft
					end,

					repl_open_cmd = view.split.vertical.botright("40%"),
					-- repl_open_cmd = view.bottom("40%"),
				},
				highlight = { italic = true },
				ignore_blank_lines = true,
			})
			-- ここに上記のsetupの記述が入る。
			vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr><ESC>", { desc = "Start Repl" })
			vim.keymap.set("n", "<leader>rR", "<cmd>IronRestart<cr><ESC>", { desc = "Restart Repl" })
			vim.keymap.set("n", "<leader>rF", "<cmd>IronFocus<cr><ESC>", { desc = "Focus Repl" })
			vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr><ESC>", { desc = "Hide Repl" })
			-- vim.keymap.set("n", "<leader>rr", core.toggle_repl, { desc = "toggle REPL" })
			vim.keymap.set("n", "<leader>rc", core.send_motion, { desc = "Send motion" })
			vim.keymap.set("n", "<leader>rf", core.send_file, { desc = "Send file" })
			vim.keymap.set("n", "<leader>rl", core.send_line, { desc = "Send line" })
			vim.keymap.set("n", "<C-CR>", line_send_and_move_down, { desc = "Send line" })
			vim.keymap.set("n", "<leader>rms", core.send_mark, { desc = "Mark send" })
			vim.keymap.set("n", "<leader>rmc", core.mark_motion, { desc = "Mark motion" })
			vim.keymap.set("n", "<leader>rq", core.close_repl, { desc = "Exit" })
			vim.keymap.set("n", "<leader>rmd", marks.drop_last, { desc = "Mark delete" })
			vim.keymap.set("n", "<leader>r<CR>", function()
				core.send(nil, string.char(13))
			end, { desc = "Carriage return" })
			vim.keymap.set("n", "<leader>r<space>", function()
				core.send(nil, string.char(03))
			end, { desc = "Interrupt" })
			vim.keymap.set("n", "<leader>rx", function()
				core.send(nil, string.char(12))
			end, { desc = "Clear" })
			vim.keymap.set("v", "<leader>rc", core.visual_send, { desc = "Send visual" })
			vim.keymap.set("v", "<C-CR>", visual_send_and_move_down, { desc = "Send visual" })
			vim.keymap.set("v", "<leader>rmc", core.mark_visual, { desc = "Mark visual" })
		end,
	},
	{
		name = "which-key.nvim",
		dir = "@which_key_nvim@",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<LEADER>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
