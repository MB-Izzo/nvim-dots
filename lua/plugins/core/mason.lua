local mylsp = require("lspconfig")
return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "mason-org/mason.nvim", opts = {}, branch = "main" },
			{ "mason-org/mason-lspconfig.nvim", branch = "main" },
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "Configure LSP keymaps",
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end
					mylsp.on_attach(client, args.buf)
				end,
			})
			vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
				once = true,
				callback = function()
					-- Extend neovim's client capabilities with the completion ones.
					--vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })
				end,
			})

			-- auto vim.enable installed lsp!
			require("mason-lspconfig").setup({
				ensure_installed = { "ts_ls" },
				handlers = {
					function(server_name)
						--		    local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						--		    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						--vim.lsp.config[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
