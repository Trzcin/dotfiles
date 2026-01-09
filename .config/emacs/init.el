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
    (frame-title-format "%b")
    (help-window-select t)
    (enable-recursive-minibuffers t)

    ;; Line height
    (default-text-properties '(line-spacing 0.125 line-height 1.125)) ;; causes issues with vterm

    (custom-file (locate-user-emacs-file "custom.el"))

    :hook
    (prog-mode . display-line-numbers-mode)

    :init
    (scroll-bar-mode -1)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (fringe-mode 0)
    (blink-cursor-mode -1)
    (global-hl-line-mode)
    (global-auto-revert-mode) ;; Keep unmodified buffers up to date with files
    (recentf-mode)
    (savehist-mode)
    (file-name-shadow-mode)
    (modify-coding-system-alist 'file "" 'utf-8)

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
    (dired-free-space nil)

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

(use-package orderless
    :ensure t
    :after vertico
    
    :custom
    (completion-styles '(orderless basic))
    (completion-category-defaults nil)
    (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
    :ensure t
    :defer t

    :custom
    ;; Only show buffers in `consult-buffer`
    (consult-buffer-sources '(consult-source-buffer consult-source-hidden-buffer
                                                    consult-source-modified-buffer
                                                    consult-source-other-buffer)))

(defvar-keymap my/leader-map)

(use-package embark
    :ensure t
    :bind (:map my/leader-map
        ("E" . embark-act)
    ))

(use-package embark-consult
    :ensure t
    :hook
    (embark-collect-mode . consult-preview-at-point-mode))

;; Vim motions
(use-package evil
    :ensure t
    :hook
    (after-init . evil-mode)

    :custom
    (evil-want-keybinding nil)
    (evil-want-Y-yank-to-eol t)
    (evil-want-fine-undo t)
    (evil-leader/in-all-states t)

    :bind (
        :map evil-normal-state-map
        ("-" . dired-jump) ;; Jump to parent directory

        :map my/leader-map
        ;; Clipbaord
        ("Y" . clipboard-kill-ring-save)
        ("P" . clipboard-yank)

        ;; Find stuff
        ("f f" . find-file)
        ("f r" . consult-recent-file)

        ;; Buffers
        ("b b" . consult-buffer)
        ("b i" . ibuffer)

        ;; Remap prefixes to evil leader
        ("h" . help-command)
        ("w" . evil-window-map)
    )

    :config
    (evil-set-undo-system 'undo-tree)
    (keymap-set evil-normal-state-map "SPC" my/leader-map) ; Probably cleaner to use keymaps rather than `evil-set-leader`
    (keymap-set evil-visual-state-map "SPC" my/leader-map) ; Probably cleaner to use keymaps rather than `evil-set-leader`
    
    ;; Commenting
    (evil-define-key 'normal 'global (kbd "gcc")
                     (lambda ()
                       (interactive)
                       (if (not (use-region-p))
                           (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))
    
    (evil-define-key 'visual 'global (kbd "gc")
                     (lambda ()
                       (interactive)
                       (if (use-region-p)
                           (comment-or-uncomment-region (region-beginning) (region-end))))))

(use-package evil-collection
    :ensure t
    :after evil
    :hook
    (evil-mode . evil-collection-init)

    :custom
    (evil-collection-want-find-usages-bindings t)
    (evil-collection-key-blacklist '("SPC")) ; Stop evil-collection from using leader keys
    (evil-collection-setup-minibuffer t))

(use-package undo-tree
    :ensure t
    :hook
    (after-init . global-undo-tree-mode)
    
    :custom
    (undo-tree-visualizer-timestamps t)
    (undo-tree-visualizer-diff t)
    (undo-limit 800000)
    (undo-strong-limit 12000000)
    (undo-outer-limit 120000000)
    (undo-tree-history-directory-alist '(("." . "~/.config/emacs/undotree"))))

;; Icons
(use-package nerd-icons
    :ensure t
    :custom
    (nerd-icons-font-family "JetBrainsMono Nerd Font"))

(use-package nerd-icons-dired
    :ensure t
    :hook
    (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
    :ensure t
    :after marginalia
    :hook
    (marginalia-mode . nerd-icons-completion-marginalia-setup)

    :config
    (nerd-icons-completion-mode))

(use-package nerd-icons-ibuffer
    :ensure t
    :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package vterm
    :ensure t

    :config
    (setq vterm-timer-delay 0.01)

    :bind (:map my/leader-map
        ("o t" . vterm) ;; Open terminal
    )
    
    :hook
    (vterm-mode . (lambda ()
                    (setq-local global-hl-line-mode nil)
                    (setq-local default-text-properties nil) ; vterm does not like line-spacing
                    )))
