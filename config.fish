set fish_greeting
alias c="clear"
alias love2d="/home/trzcinkde/Applications/love-11.4-x86_64.AppImage"
alias l="exa -l --icons"

source /usr/share/autojump/autojump.fish

# pnpm
set -gx PNPM_HOME "/home/trzcinkde/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

# paths
fish_add_path -P ~/dotfiles/scripts/ 
fish_add_path -P ~/.local/share/nvim/mason/bin/
