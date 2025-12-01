local function get_codecompanion_adapter()
	local host = vim.uv.os_gethostname()
	if host == "mathieu" then
		return "mistral"
	else
		return "copilot"
	end
end

return {
	{

		"olimorris/codecompanion.nvim",
		tag = "v17.33.0",
		enabled = function()
			return vim.env.MISTRAL_API_KEY ~= nil or vim.env.COPILOT_API_KEY ~= nil
		end,
		opts = {
			adapter = get_codecompanion_adapter(),
			strategies = {
				chat = {
					adapter = get_codecompanion_adapter(),
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
