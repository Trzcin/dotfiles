vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("n", "<C-s>", ":w<cr>") -- save
keymap.set("n", "<leader>sc", ":nohl<cr>") -- clear search
keymap.set("n", "<C-a>", "ggVG") -- highligh file
keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>") -- toggle NvimTree
keymap.set("n", "<C-w>-", "<C-w>s") -- split horizontal
keymap.set("n", "<C-w>|", "<C-w>v") -- split vertical

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- make indentation stack
keymap.set("v", ">", ">gv^")
keymap.set("v", "<", "<gv^")

-- buffers
keymap.set("n", "<tab>[", ":bp<cr>")
keymap.set("n", "<tab>]", ":bn<cr>")
keymap.set("n", "<tab>d", ":bd<cr>")
