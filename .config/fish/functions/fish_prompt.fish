function fish_prompt
    string join '' -- \
        (set_color cyan) ' ' (string replace "/home/$USER" "~" $PWD) \
        (set_color green) (string replace -r "^ " "  " (fish_git_prompt)) (set_color normal) \
        ' > '
end
