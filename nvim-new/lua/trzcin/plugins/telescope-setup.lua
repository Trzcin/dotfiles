-- fuzzy finder

return {
    "nvim-telescope/telescope.nvim", 
    version = "0.1.1",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make"
        }
    },
    lazy = true,
    config = function()
        local telescope = require("telescope")
        telescope.setup()
        telescope.load_extension("fzf")
        telescope.load_extension("notify")
    end,
    cmd = "Telescope"
}
