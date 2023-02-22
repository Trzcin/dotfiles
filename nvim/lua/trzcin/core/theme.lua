local theme = 'catppuccin-macchiato'
local status, _ = pcall(vim.cmd, string.format('colorscheme %s', theme))
if not status then
    print('Theme', theme, 'was not found')
    return
end
