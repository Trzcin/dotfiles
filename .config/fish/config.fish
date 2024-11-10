# disable startup message
set fish_greeting

# vi mode with system clipboard
fish_vi_key_bindings
bind -M visual y fish_clipboard_copy
bind yy fish_clipboard_copy
bind p fish_clipboard_paste

# path
fish_add_path ~/go/bin

# abbreviations
abbr -a c clear
abbr -a l ls -gah
abbr -a lg lazygit
