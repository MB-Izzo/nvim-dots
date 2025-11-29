-- Use an indentation of 4 spaces.
vim.o.sw = 4
vim.o.ts = 4
vim.o.et = true

-- Show whitespace.
--vim.o.list = true
--vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.wo.number = true
vim.o.relativenumber = true

vim.o.linebreak = true

-- Save undo history.
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or the search has capitals.
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.completeopt = "menuone,noselect,noinsert"
vim.o.pumheight = 15
--vim.o.pumborder = "rounded"
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.mouse = "a"
-- Update times and timeouts.
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
