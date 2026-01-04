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

;; Vim motions
(use-package evil
    :ensure t
    
    :hook
    (after-init . evil-mode)
    
    :init
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    
    :config
    (evil-set-undo-system 'undo-tree)
    
    (setq evil-leader/in-all-states t)
    (setq evil-want-fine-undo t)
    
    ;; Define the leader key as Space
    (evil-set-leader 'normal (kbd "SPC"))
    (evil-set-leader 'visual (kbd "SPC"))
    
    ;; Dired commands for file management
    (evil-define-key 'normal 'global (kbd "-") 'dired-jump)
    (evil-define-key 'normal 'global (kbd "<leader> x f") 'find-file)
    
    ;; Buffer management keybindings
    ;; (evil-define-key 'normal 'global (kbd "<leader> b i") 'consult-buffer) ;; Open consult buffer list
    (evil-define-key 'normal 'global (kbd "<leader> b b") 'switch-to-buffer)
    (evil-define-key 'normal 'global (kbd "<leader> b d") 'kill-current-buffer)
    (evil-define-key 'normal 'global (kbd "<leader> b s") 'save-buffer)
    ;; (evil-define-key 'normal 'global (kbd "<leader> b l") 'consult-buffer) ;; Consult buffer
    ;; (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer) ;; Consult buffer
    
    ;; Project management keybindings
    ;; (evil-define-key 'normal 'global (kbd "<leader> p b") 'consult-project-buffer) ;; Consult project buffer
    (evil-define-key 'normal 'global (kbd "<leader> p p") 'project-switch-project)
    (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
    (evil-define-key 'normal 'global (kbd "<leader> p g") 'project-find-regexp)
    (evil-define-key 'normal 'global (kbd "<leader> p k") 'project-kill-buffers)
    (evil-define-key 'normal 'global (kbd "<leader> p D") 'project-dired)
    
    ;; Help keybindings
    ;; TODO - finish this
    (evil-define-key 'normal 'global (kbd "<leader> h m") 'describe-mode)
    (evil-define-key 'normal 'global (kbd "<leader> h f") 'describe-function)
    (evil-define-key 'normal 'global (kbd "<leader> h v") 'describe-variable)
    (evil-define-key 'normal 'global (kbd "<leader> h k") 'describe-key)

    ;; Window keybindings
    (evil-define-key 'normal 'global (kbd "<leader> w s") 'evil-window-split)
    (evil-define-key 'normal 'global (kbd "<leader> w v") 'evil-window-vsplit)
    (evil-define-key 'normal 'global (kbd "<leader> w h") 'evil-window-left)
    (evil-define-key 'normal 'global (kbd "<leader> w j") 'evil-window-down)
    (evil-define-key 'normal 'global (kbd "<leader> w k") 'evil-window-up)
    (evil-define-key 'normal 'global (kbd "<leader> w l") 'evil-window-right)
    (evil-define-key 'normal 'global (kbd "<leader> w q") 'evil-quit)

    ;; Commenting functionality for single and multiple lines
    (evil-define-key 'normal 'global (kbd "gcc")
                     (lambda ()
                       (interactive)
                       (if (not (use-region-p))
                           (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))
    
    (evil-define-key 'visual 'global (kbd "gc")
                     (lambda ()
                       (interactive)
                       (if (use-region-p)
                           (comment-or-uncomment-region (region-beginning) (region-end)))))
    
    (evil-mode 1))

(use-package evil-collection
    :ensure t
    :custom
    (evil-collection-want-find-usages-bindings t)
    
    :hook
    (evil-mode . evil-collection-init))

(use-package undo-tree
    :ensure t
    
    :hook
    (after-init . global-undo-tree-mode)
    
    :init
    (setq undo-tree-visualizer-timestamps t
          undo-tree-visualizer-diff t
          undo-limit 800000
          undo-strong-limit 12000000
          undo-outer-limit 120000000)
    
    :config
    (setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undotree"))))
