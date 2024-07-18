vim.g.mapleader = " "
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- make paragraph jumps skip blank lines
vim.keymap.set("n", "}", "}j^")
vim.keymap.set("n", "{", "k{j^")

-- undo/redo
vim.keymap.set("n", "U", "<C-r>")

if vim.g.vscode then
  local vscode = require("vscode-neovim")

  vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.next") end)
  vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.prev") end)
  vim.keymap.set("n", "gI", function() vscode.action("editor.action.peekImplementation") end)
  vim.keymap.set("n", "gt", function() vscode.action("editor.action.goToTypeDefinition") end)
  vim.keymap.set("n", "gT", function() vscode.action("editor.action.peekTypeDefinition") end)
  vim.keymap.set("n", "]c", function() vscode.action("workbench.action.editor.nextChange") end)
  vim.keymap.set("n", "[c", function() vscode.action("workbench.action.editor.previousChange") end)
end
