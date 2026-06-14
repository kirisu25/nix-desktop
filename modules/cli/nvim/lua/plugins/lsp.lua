return {
	{
		name = "nvim-cmp",
		dir = "@nvim_cmp@",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ name = "cmp-buffer", dir = "@cmp_buffer@" },
			{ name = "cmp-nvim-lsp", dir = "@cmp_nvim_lsp@" },
			{ name = "cmp-path", dir = "@cmp_path@" },
			{
				name = "cmp_luasnip",
				dir = "@cmp_luasnip@",
				dependencies = { name = "LuaSnip", dir = "@luasnip@" },
			},
			{ name = "cmp-cmdline", dir = "@cmp_cmdline@" },
			{ name = "lspkind.nvim", dir = "@lspkind_nvim@" },
		},
		opts = function()
			vim.g.completeopt = "menu,menuone,noselect"
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local has_words_before = function()
				local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
				}),
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-l>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({}),
				},
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				source = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	{
		name = "nvim-lspconfig",
		dir = "@nvim_lspconfig@",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "diag:open float" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "diag:goto prev" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "diag:goto next" })
			vim.keymap.set("n", "<space>l", vim.diagnostic.setloclist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "gwa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "gwr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "gwl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			vim.lsp.config("rust_analyzer", {
				setings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.enable("gopls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("nil_ls")
			-- vim.lsp.enable("qmlls")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("zls")
		end,
	},
	{
		name = "none-ls.nvim",
		dir = "@none_ls_nvim@",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.nixfmt,
					null_ls.builtins.formatting.qmlformat,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.rustfmt,
				},
			})
		end,
	},
	{
		name = "lspsaga.nvim",
		dir = "@lspsaga_nvim@",
		event = "BufRead",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					sign = false,
				},
			})
		end,
	},
}
