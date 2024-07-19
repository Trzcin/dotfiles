set fish_greeting
fish_vi_key_bindings

bind -M visual y fish_clipboard_copy
bind yy fish_clipboard_copy
bind p fish_clipboard_paste

abbr -a c clear
abbr -a l ls -g -h
abbr -a --position command code code --ozone-platform=wayland

set NVCC_PREPEND_FLAGS "-ccbin /home/linuxbrew/.linuxbrew/bin/g++-13"

fish_add_path -P /home/trzcin/go/bin/
fish_add_path -P /home/trzcin/.local/bin/
fish_add_path -P /home/linuxbrew/.linuxbrew/bin/
