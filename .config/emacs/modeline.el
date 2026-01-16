(defvar-local my/mode-line-pos
    '(:eval (when (mode-line-window-selected-p)
                (list "l: %l/"
                      (number-to-string (line-number-at-pos (point-max)))
                      "  "
                      "c: %c")))
    "Point line and column position string for the modeline.")
(put 'my/mode-line-pos 'risky-local-variable t)

(defvar-local my/mode-line-buffer-name
    '(:eval (cond ((project-current) (file-relative-name buffer-file-name (project-root (project-current))))
                  (buffer-file-name buffer-file-name)
                  (t "%b")))
    "Name of the current buffer or file path.")
(put 'my/mode-line-buffer-name 'risky-local-variable t)

(defvar-local my/mode-line-buffer-status
    '(:eval "%+")
    "Visual representation of the buffer status.")
(put 'my/mode-line-buffer-status 'risky-local-variable t)

(defvar-local my/mode-line-major-mode
    '(:eval (string-replace "-" " " (capitalize (symbol-name major-mode))))
    "Visual representation of the buffer status.")
(put 'my/mode-line-major-mode 'risky-local-variable t)

;; See 'https://protesilaos.com/dotemacs'
(defun my/mode-line--vc-branch-name (file backend)
    "Return VC branch name for FILE with BACKEND."
    (when-let* ((rev (vc-working-revision file backend)))
                (or (vc-git--symbolic-ref file)
                    (substring rev 0 7))))

(defvar-local my/mode-line-vc-branch
    '(:eval
      (when-let* (((mode-line-window-selected-p))
                  (file (or buffer-file-name default-directory))
                  (backend (or (vc-backend file) 'Git)))
            (my/mode-line--vc-branch-name file backend)))
    "Mode line construct to return propertized VC branch.")
(put 'my/mode-line-vc-branch 'risky-local-variable t)

(setq-default mode-line-format
              '(" "
                my/mode-line-buffer-name
                " "
                my/mode-line-buffer-status
                "  "
                my/mode-line-major-mode
                "  "
                my/mode-line-vc-branch
                mode-line-format-right-align
                my/mode-line-pos
                " "))
