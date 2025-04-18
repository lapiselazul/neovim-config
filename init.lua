require("config.lazy")

local set = vim.opt

set.shiftwidth = 2
set.tabstop = 2
set.softtabstop = 0
set.expandtab = true

set.number = true
set.relativenumber = true
set.cursorline = true

-- For quickfix
vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>")
