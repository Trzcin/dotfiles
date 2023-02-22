local status, nvim_tree = pcall(require, 'nvim-tree')
if not status then
    print('nvim-tree not found')
    return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
    sort_by = 'extension'
})
