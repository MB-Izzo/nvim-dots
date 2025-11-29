return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "nvim-mini/mini.icons" },
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
		{ "<leader>ss", "<cmd>FzfLua builtin<cr>", desc = "Built ins" },
		{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Search keymaps" },
		{ "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = " Search grep" },
		{ "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Search diagnostics" },
		{ "<leader>s;", "<cmd>FzfLua buffers<cr>", desc = "Search buffer" },
	},
	opts = function()
		return {
			winopts = {
				height = 0.9,
				width = 0.85,
				preview = {
					scrollbar = false,
					layout = "horizontal",
					horizontal = "right:60%",
				},
			},
		}
	end,
}
