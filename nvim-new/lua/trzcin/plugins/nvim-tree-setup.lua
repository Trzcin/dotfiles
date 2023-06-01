-- file explorer

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = "NvimTreeToggle",
    config = function() 
        require("nvim-tree").setup({
            sort_by = "extension",
            renderer = {
                group_empty = true,
            },
        })
    end
}
