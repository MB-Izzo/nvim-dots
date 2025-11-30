return {
	{

		"olimorris/codecompanion.nvim",
		tag = "v17.33.0",
		enabled = function()
			return vim.env.MISTRAL_API_KEY ~= nil
		end,
		opts = {
			adapter = "mistral",
			strategies = {
				chat = {
					adapter = "mistral",
					keymaps = {
						send = {
							modes = { n = "<CR>", i = "<CR>" },
							opts = {},
						},
						close = {
							modes = { n = "<C-s>", i = "<C-s>" },
							opts = {},
						},
					},
				},
			},
			extensions = {
				spinner = {},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- to get a nice spinner while waiting for response
			"franco-ruggeri/codecompanion-spinner.nvim",
		},
	},
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
}
