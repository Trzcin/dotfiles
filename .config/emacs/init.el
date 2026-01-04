;; Add MELPA to package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; General Emacs settings
(use-package emacs
    :ensure nil
    :custom
    ;; Disable autosave, backups, lockfiles etc.
    (auto-save-default nil)
    (auto-save-list-file-prefix nil)
    (create-lockfiles nil)
    (make-backup-files nil)
    
    (delete-by-moving-to-trash t)
    (global-auto-revert-non-file-buffers t)

    ;; Indentation
    (indent-tabs-mode nil)
    (tab-width 4)

    ;; Line and column numbers
    (column-number-mode t)
    (display-line-numbers-type 'relative)
    (display-line-numbers-width 3)

    ;; Scrolling
    (pixel-scroll-precision-mode t)
    (scroll-conservatively 101)

    (ring-bell-function 'ignore) ;; Disable bell audio

    (switch-to-buffer-obey-display-actions t)
    (treesit-font-lock-level 4) ;; Use treesitter where possible
    (truncate-lines t) ;; Disable line wrap
    (use-dialog-box nil) ;; Prefer minibuffer to dialog boxes
    (use-short-answers t) ;; Shorten yes/no to y/n

    ;; Line height
    (default-text-properties '(line-spacing 0.125 line-height 1.125))

    :hook
    (prog-mode . display-line-numbers-mode)

    :init
    (scroll-bar-mode -1)
    (fringe-mode 0)
    (blink-cursor-mode -1)
    (global-hl-line-mode)
    (global-auto-revert-mode) ;; Keep unmodified buffers up to date with files
    (recentf-mode)
    (savehist-mode)
    (save-place-mode)
    (file-name-shadow-mode)
    (modify-coding-system-alist 'file "" 'utf-8)
    (setq custom-file (locate-user-emacs-file "custom.el")) ;; Store customize stuff in separate file

    :config
    ;; Fonts
    (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'fixed-pitch nil :family "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'variable-pitch nil :family "Inter" :height 120)

    (load custom-file 'noerror 'nomessage))

;; Theme
(use-package modus-themes
    :ensure nil
    :init
    (load-theme 'modus-operandi t))

;; Dired
(use-package dired
    :ensure nil
    :custom
    (dired-recursive-copies 'always)
    (dired-recursive-deletes 'always)
    (dired-listing-switches "-AGFhlv --group-directories-first")
    (dired-dwim-target t) ;; Easy dual pane usage for moving files
    (dired-kill-when-opening-new-dired-buffer t)

    :hook
    (dired-mode . dired-hide-details-mode))

;; which-key - show possible keybinds
(use-package which-key
    :ensure nil
    :hook
    (after-init . which-key-mode))

;; Minibuffer enchancements
(use-package vertico
    :ensure t
    :hook
    (after-init . vertico-mode))

(use-package marginalia
    :ensure t
    :hook
    (after-init . marginalia-mode))
