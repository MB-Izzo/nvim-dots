return {
	"github/copilot.vim",
		enabled = function()
			return vim.env.COPILOT_API_KEY ~= nil
		end,
	config = function()
		-- Disable Copilot's inline suggestions
        vim.g.copilot_enabled = false
	end,
}
