local M = {}
local diagnostic_icons = require("icons").diagnostics

function M.on_attach(client, bufnr)
	---@param lhs string
	---@param rhs string|function
	---@param opts string|vim.keymap.set.Opts
	---@param mode? string|string[]
	local function keymap(lhs, rhs, opts, mode)
		mode = mode or "n"
		---@cast opts vim.keymap.set.Opts
		opts = type(opts) == "string" and { desc = opts } or opts
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	keymap("[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous diagnostic")
	keymap("]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next diagnostic")
	keymap("[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
	end, "Previous error")
	keymap("]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
	end, "Next error")

	keymap("gp", function()
		vim.lsp.buf.format()
	end, "Format buffer")

	if client:supports_method("textDocument/codeAction") then
		--require('lightbulb').attach_lightbulb(bufnr, client)
		keymap("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction")
	end

	-- Don't check for the capability here to allow dynamic registration of the request.
	--    vim.lsp.document_color.enable(true, bufnr)
	if client:supports_method("textDocument/documentColor") then
		keymap("grc", function()
			vim.lsp.document_color.color_presentation()
		end, "vim.lsp.document_color.color_presentation()", { "n", "x" })
	end

	if client:supports_method("textDocument/references") then
		keymap("grr", "<cmd>FzfLua lsp_references<cr>", "vim.lsp.buf.references()")
	end

	if client:supports_method("textDocument/typeDefinition") then
		keymap("gy", "<cmd>FzfLua lsp_typedefs<cr>", "Go to type definition")
	end

	if client:supports_method("textDocument/documentSymbol") then
		keymap("<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "Document symbols")
	end

	if client:supports_method("textDocument/definition") then
		keymap("gd", function()
			require("fzf-lua").lsp_definitions({ jump1 = true })
		end, "Go to definition")
		keymap("gD", function()
			require("fzf-lua").lsp_definitions({ jump1 = false })
		end, "Peek definition")
	end

	if client:supports_method("textDocument/signatureHelp") then
		keymap("<C-k>", function()
			-- Close the completion menu first (if open).
			if require("blink.cmp.completion.windows.menu").win:is_open() then
				require("blink.cmp").hide()
			end

			vim.lsp.buf.signature_help()
		end, "Signature help", "i")
	end

	if client:supports_method("textDocument/documentHighlight") then
		local under_cursor_highlights_group =
			vim.api.nvim_create_augroup("mariasolos/cursor_highlights", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Highlight references under the cursor",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Clear highlight references",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	if client:supports_method("textDocument/inlayHint") then
		local inlay_hints_group = vim.api.nvim_create_augroup("mariasolos/toggle_inlay_hints", { clear = false })

		if vim.g.inlay_hints then
			-- Initial inlay hint display.
			-- Idk why but without the delay inlay hints aren't displayed at the very start.
			vim.defer_fn(function()
				local mode = vim.api.nvim_get_mode().mode
				vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
			end, 500)
		end

		vim.api.nvim_create_autocmd("InsertEnter", {
			group = inlay_hints_group,
			desc = "Enable inlay hints",
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
				end
			end,
		})

		vim.api.nvim_create_autocmd("InsertLeave", {
			group = inlay_hints_group,
			desc = "Disable inlay hints",
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end,
		})
	end
end

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostic_icons) do
	local hl = "DiagnosticSign" .. severity:sub(1, 1) .. severity:sub(2):lower()
	vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- Diagnostic configuration.
vim.diagnostic.config({
	status = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
			[vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
			[vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
			[vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
		},
	},
	virtual_text = {
		prefix = "",
		spacing = 2,
		format = function(diagnostic)
			local icon = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
			return string.format("%s %s", icon, diagnostic.message)
		end,
	},
	float = {
		source = "if_many",
		-- Show severity icons as prefixes.
		prefix = function(diag)
			local level = vim.diagnostic.severity[diag.severity]
			local prefix = string.format(" %s ", diagnostic_icons[level])
			return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
		end,
	},
	-- Disable signs in the gutter.
	signs = false,
})

return M
