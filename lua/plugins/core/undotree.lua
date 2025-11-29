return {
	"jiaoshijie/undotree",
	---@module 'undotree.collector'
	---@type UndoTreeCollector.Opts
	opts = {
		-- your options
		window = {
			winblend = 0,
		},
	},
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}
