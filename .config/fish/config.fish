# fish with fisher plugin manager and the tide prompt

# disable startup message
set fish_greeting

# vi mode with system clipboard
fish_vi_key_bindings
bind -M visual y fish_clipboard_copy
bind yy fish_clipboard_copy
bind p fish_clipboard_paste

# tide customizations
set tide_git_icon ''

# abbreviations
abbr -a c clear
abbr -a l ls -gh
abbr -a code code --ozone-platform=wayland
abbr -a lg lazygit
abbr -a b bluetoothctl

# path
fish_add_path -P ~/go/bin/
fish_add_path -P ~/.local/bin/

# color man pages with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
