vim.g.mapleader = " "

vim.keymap.set("n", "<C-s>", ":w<cr>") -- save file
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>") -- toggle file explorer
vim.keymap.set("n", "<leader>q", ":qa<cr>") -- quit
vim.keymap.set("n", "<leader>sc", ":nohl<cr>") -- clear search highlight

-- better indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope notify<cr>") -- find messages

-- git-signs
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>")
vim.keymap.set("n", "[h]", "<cmd>Gitsigns prev_hunk<cr>")

-- move lines
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<cr>") -- move line down
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<cr>") -- move line up
vim.keymap.set("v", "<M-j>", ":m '>+1<cr>gv") -- move lines down
vim.keymap.set("v", "<M-k>", ":m '<-2<cr>gv") -- move lines up
