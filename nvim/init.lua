vim.g.mapleader = " "
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- undo/redo
vim.keymap.set("n", "U", "<C-r>")

-- system clipboard copy/paste
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

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
end
