vim.g.mapleader = " "

-- move lines
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- Helix like redo
vim.keymap.set("n", "U", "<C-r>")

-- system clipboard copy/paste
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p')

-- select file
vim.keymap.set("n", "<leader>a", 'ggVG')

if vim.g.vscode then
  local vscode = require("vscode-neovim")

  vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.next") end)
  vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.prev") end)
  vim.keymap.set("n", "gI", function() vscode.action("editor.action.peekImplementation") end)
  vim.keymap.set("n", "gt", function() vscode.action("editor.action.goToTypeDefinition") end)
  vim.keymap.set("n", "gT", function() vscode.action("editor.action.peekTypeDefinition") end)
  vim.keymap.set("n", "gs", function() vscode.action("typescript.goToSourceDefinition") end)
  vim.keymap.set("n", "]c", function() vscode.action("workbench.action.editor.nextChange") end)
  vim.keymap.set("n", "[c", function() vscode.action("workbench.action.editor.previousChange") end)

  -- tests
  vim.keymap.set("n", "]t", "/\\(^\\s*\\)\\@<=\\(test\\)<CR><CMD>nohl<CR>")
  vim.keymap.set("n", "[t", "?\\(^\\s*\\)\\@<=\\(test\\)<CR><CMD>nohl<CR>")

  vim.keymap.set("n", "<leader>t", function() vscode.action("testing.runAtCursor") end)
  vim.keymap.set("n", "<leader>T", function() vscode.action("testing.runCurrentFile") end)
end
