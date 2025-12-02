return {
	"zbirenbaum/copilot.lua",
    enabled = function()
        return vim.env.COPILOT_API_KEY ~= nil
    end,
    opts = {
        suggestion = { enabled = false },
    },
}
