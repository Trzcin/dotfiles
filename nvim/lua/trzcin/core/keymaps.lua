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
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>") -- search undos
