local parsers = {
	"bash",
	"blade",
	"c",
	"comment",
	"cpp",
	"css",
	"csv",
	"git_config",
	"git_rebase",
	"gitattributes",
	--  'gitcommit',
	"gitignore",
	"go",
	"html",
	"ini",
	"javascript",
	"json",
	"json5",
	"jsonc",
	"jsdoc",
	"lua",
	"luadoc",
	"make",
	"markdown",
	"markdown_inline",
	"php",
	"php_only",
	"phpdoc",
	"regex",
	"rust",
	"sql",
	"ssh_config",
	"toml",
	"typescript",
	"tsx",
	"typescriptreact",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		},
		config = function(_, opts)
			local nts = require("nvim-treesitter")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = parsers,
				callback = function()
					vim.treesitter.start()
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					local configs = require("nvim-treesitter.parsers")

					-- configs.blade.install_info = {
					--   path = '~/sources/treesitter/tree-sitter-blade',
					--   generate = true,
					--   generate_from_json = true,
					-- }

					-- configs.phpdoc.install_info = {
					--   path = '~/sources/treesitter/tree-sitter-phpdoc',
					--   generate = true,
					--   generate_from_json = true,
					-- }

					-- configs.php.install_info = {
					--   path = '~/sources/treesitter/tree-sitter-php',
					--   location = 'php',
					--   generate = true,
					--   generate_from_json = true,
					-- }

					-- configs.php_only.install_info = {
					--   path = '~/sources/treesitter/tree-sitter-php',
					--   location = 'php_only',
					--   generate = true,
					--   generate_from_json = true,
					-- }
				end,
			})

			nts.setup(opts)
			nts.install(parsers)
		end,
	},
}
