; Add MELPA to package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Global leader map
(defvar-keymap my/leader-map)

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
    (text-mode . visual-line-mode) ;; Enable word wrap for prose
    (astro-ts-mode . display-line-numbers-mode)

    :init
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

(use-package ef-themes
    :ensure t)

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

;; Projects
;; Tip: run `(project-remember-projects-under "<path>" t)` to discover projects in subdirectories
(use-package project
    :ensure nil
    :config
    (keymap-set my/leader-map "p" project-prefix-map)

    ;; Make <leader>ps open vterm for project
    (defun my/project-vterm ()
        (interactive)
        (require 'comint)
        (let* ((default-directory (project-root (project-current t)))
                (default-project-shell-name (project-prefixed-buffer-name "shell"))
                (shell-buffer (get-buffer default-project-shell-name)))
            (if (and shell-buffer (not current-prefix-arg))
                (if (comint-check-proc shell-buffer)
                    (pop-to-buffer shell-buffer (bound-and-true-p display-comint-buffer-action))
                (vterm shell-buffer))
            (vterm (generate-new-buffer-name default-project-shell-name)))))

    (advice-add 'project-shell :override #'my/project-vterm))

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

    :bind (:map my/leader-map
        ("c l" . consult-line)  
        ("c t" . consult-theme)  
        ("c i" . consult-info)  
        ("c m" . consult-man)  
        ("c o" . consult-outline)  
        ("c g" . consult-ripgrep)  
        ("c f" . consult-fd)  
        ("c s" . consult-imenu) ;; Consult symbols
    )

    :custom
    ;; Only show buffers in `consult-buffer`
    (consult-buffer-sources '(consult-source-buffer consult-source-hidden-buffer
                                                    consult-source-modified-buffer
                                                    consult-source-other-buffer)))

(use-package embark
    :ensure t
    :bind (:map my/leader-map
        ("e" . embark-act)
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
        ("f l" . find-library)

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
    (nerd-icons-font-family "JetBrainsMono Nerd Font")
    :config
    (add-to-list 'nerd-icons-extension-icon-alist '("astro" nerd-icons-devicon "nf-dev-astro" :face nerd-icons-orange)))

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

    :bind (
        :map my/leader-map
        ("o t" . vterm) ;; Open terminal

        :map vterm-mode-map
        ("C-<escape>" . (lambda () (interactive) (vterm-copy-mode)
                          (turn-on-evil-mode)
                          (evil-normal-state)))
    )

    :config
    (setq vterm-timer-delay 0.01)
    (evil-define-key 'normal 'vterm-mode-map (kbd "i") (lambda () (interactive) (turn-off-evil-mode)
                                                                                (vterm-copy-mode -1)))
    
    :hook
    (vterm-mode . (lambda ()
                    (setq-local global-hl-line-mode nil)
                    (setq-local default-text-properties nil) ; vterm does not like line-spacing
                    (turn-off-evil-mode)
                    )))

;; Treesitter major modes packages
(use-package html-ts-mode :ensure nil)
(use-package c-ts-mode :ensure nil)
(use-package yaml-ts-mode :ensure nil)
(use-package dockerfile-ts-mode :ensure nil)
(use-package go-ts-mode :ensure nil)
(use-package lua-ts-mode :ensure nil)
(use-package php-ts-mode :ensure nil)
(use-package heex-ts-mode :ensure nil)
(use-package java-ts-mode :ensure nil)
(use-package json-ts-mode :ensure nil)
(use-package ruby-ts-mode :ensure nil)
(use-package rust-ts-mode :ensure nil)
(use-package toml-ts-mode :ensure nil)
(use-package cmake-ts-mode :ensure nil)
(use-package elixir-ts-mode :ensure nil)
(use-package typescript-ts-mode :ensure nil)
(use-package astro-ts-mode :ensure t)
;; (use-package markdown-ts-mode
;;     :ensure t
;;     :mode ("\\.md\\'" . markdown-ts-mode))
(use-package svelte-ts-mode
    :vc (:url "https://github.com/leafOfTree/svelte-ts-mode.git"
              :rev "7fdb9816535692bfd8cd85baa0f2bad052369233")
    :mode "\\.svelte\\'")
(use-package vue-ts-mode
    :vc (:url "https://github.com/theschmocker/vue-ts-mode.git"
         :rev "b1ba7195917cda08ffeac797e14bac0353c1dbe7")
    :mode "\\.vue\\'")

;; Where to get Treesitter grammars
(setq treesit-language-source-alist
      '((dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (astro "https://github.com/virchau13/tree-sitter-astro")
        (vue "https://github.com/ikatyang/tree-sitter-vue")
        (svelte "https://github.com/Himujjal/tree-sitter-svelte")
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

;; Remap modes to use Treesitter versions
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))
(add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
(add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode))
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))

;; Filename major mode custom associations
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\|.tsx\\'" . tsx-ts-mode))

;; Markdown
(use-package markdown-mode
    :ensure t
    :mode ("\\.md\\'" . markdown-mode)
    :custom
    (markdown-fontify-code-blocks-natively t)
    :config
    (custom-set-faces
        '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
        '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 2.0))))
        '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.7))))
        '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
        '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.1))))
        '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.0))))
        '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.0)))))
    :hook
    (markdown-mode . (lambda () (markdown-display-inline-images))))

;; Mixed pitch fonts
(use-package mixed-pitch
    :ensure t
    :hook
    (markdown-mode . mixed-pitch-mode))

;; Center prose buffers
(use-package olivetti
    :ensure t
    :hook
    (markdown-mode . olivetti-mode))
