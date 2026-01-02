;; Disable some UI elements
(scroll-bar-mode -1)
(fringe-mode 0)

;; Stop cursor/point from blinking
(blink-cursor-mode -1)

;; Set theme
(load-theme 'modus-operandi t)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Default frame attributes
(add-to-list 'default-frame-alist
    '(font . "JetBrains Mono-12"))

;; Disable backups, auto-saving, lockfiles, etc.
;; Important stuff is covered by git anyway
(setq
    make-backup-files nil
    auto-save-default nil
    auto-save-list-file-prefix nil
    create-lockfiles nil)

;; Shorten yes/no to y/n
(setq use-short-answers t)
