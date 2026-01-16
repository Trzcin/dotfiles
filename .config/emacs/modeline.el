(defvar-local my/mode-line-pos
    "l: %l c: %c"
    "Point line and column position string for the modeline.")

(put 'my/mode-line-pos 'risky-local-variable t)

(setq-default mode-line-format '(
                                 " " ; Narrow
                                 "%b" ; Buffer name
                                 " %&" ; Modified
                                 (vc-mode vc-mode)
                                 mode-line-format-right-align
                                 my/mode-line-pos
                                 " "))
