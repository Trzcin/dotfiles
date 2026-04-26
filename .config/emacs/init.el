(setq inhibit-startup-echo-area-message "trzcin")

;; Add MELPA to package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Global leader map
(defvar-keymap my/leader-map)

(use-package f :ensure nil)

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
    (tab-always-indent 'complete)
    (tab-width 4)
    (css-indent-offset 4)
    (lisp-indent-offset 4)
    (lua-ts-indent-offset 4)
    (heex-ts-indent-offset 4)
    (js-expr-indent-offset 4)
    (js-curly-indent-offset 4)
    (js-paren-indent-offset 4)
    (org-list-indent-offset 4)
    (c-ts-mode-indent-offset 4)
    (elixir-ts-indent-offset 4)
    (js-square-indent-offset 4)
    (js-switch-indent-offset 4)
    (go-ts-mode-indent-offset 4)
    (c-ts-common-indent-offset 4)
    (vue-ts-mode-indent-offset 4)
    (html-ts-mode-indent-offset 4)
    (java-ts-mode-indent-offset 4)
    (json-ts-mode-indent-offset 4)
    (rust-ts-mode-indent-offset 4)
    (toml-ts-mode-indent-offset 4)
    (cmake-ts-mode-indent-offset 4)
    (typescript-ts-mode-indent-offset 4)
    (markdown-list-indent-width 4)
    (lsp-magik-formatting-indent-width 4)
    (typst-ts-indent-offset 2)
    (evil-shift-width 4)

    ;; Line and column numbers
    (column-number-mode t)
    (display-line-numbers-width 3)

    ;; Scrolling
    (pixel-scroll-precision-mode t)
    (scroll-conservatively 101)

    (ring-bell-function 'ignore) ; Disable bell audio

    (switch-to-buffer-obey-display-actions t)
    (treesit-font-lock-level 4) ; Use treesitter where possible
    (truncate-lines t) ; Disable line wrap
    (use-dialog-box nil) ; Prefer minibuffer to dialog boxes
    (use-short-answers t) ; Shorten yes/no to y/n
    (frame-title-format "%b")
    (help-window-select t)
    (enable-recursive-minibuffers t)
    (inhibit-startup-screen t)
    (server-client-instructions nil)
    (browse-url-browser-function 'browse-url-xdg-open)

    ;; Clipboard
    (select-enable-clipboard nil)

    ;; use-package lazy loading stats
    ;; Tip: run M-x 'use-package-report'
    (use-package-compute-statistics t)

    ;; Line height
    (default-text-properties '(line-spacing 0.125 line-height 1.125)) ; causes issues with vterm

    :hook
    (prog-mode . (lambda () (display-line-numbers-mode)
                            (setq-local show-trailing-whitespace t)))
    (text-mode . (lambda () (visual-line-mode) ; Enable word wrap for prose
                            (setq-local show-trailing-whitespace t)))
    (astro-ts-mode . display-line-numbers-mode)
    (typst-ts-mode . display-line-numbers-mode)
    (html-ts-mode . display-line-numbers-mode)
    (yaml-ts-mode . display-line-numbers-mode)

    :init
    (blink-cursor-mode -1)
    (global-hl-line-mode)
    (global-auto-revert-mode) ; Keep unmodified buffers up to date with files
    (recentf-mode)
    (savehist-mode)
    (file-name-shadow-mode)
    (modify-coding-system-alist 'file "" 'utf-8)

    ;; Fonts
    (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'fixed-pitch nil :family "JetBrainsMono Nerd Font" :height 120)
    (set-face-attribute 'variable-pitch nil :family "Inter" :height 120)

    (put 'narrow-to-region 'disabled nil)

    ;; Load additional files
    (mapc 'load (f-files (f-join user-emacs-directory "autoload") (lambda (f) (f-ext-p f "el"))))

    ;; Customize file
    (setq custom-file (locate-user-emacs-file "custom.el"))
    (load custom-file 'noerror 'nomessage))

;; Theme
(use-package modus-themes
    :ensure nil
    :custom
    ;; Variable fonts sizes for headings
    (modus-themes-headings '((1 . (2.0))
                             (2 . (1.7))
                             (3 . (1.4))
                             (4 . (1.1)))))

(use-package ef-themes
    :ensure t
    :config
    (ef-themes-load-theme 'ef-bio))

;; Dired
(use-package dired
    :ensure nil
    :custom
    (dired-recursive-copies 'always)
    (dired-recursive-deletes 'always)
    (dired-listing-switches "-AGFhlv --group-directories-first")
    (dired-dwim-target t) ; Easy dual pane usage for moving files
    (dired-kill-when-opening-new-dired-buffer t)
    (dired-free-space nil)
    (dired-omit-files "^[.].+$")

    :config
    (evil-define-key 'normal dired-mode-map (kbd "SPC t h") 'dired-omit-mode)

    :hook
    (dired-mode . (lambda () (dired-hide-details-mode)
                      (when (and (stringp dired-directory)
                                 (string= dired-directory "~/Downloads/"))
                          ;; Sort Downloads directory by time
                          (setq-local dired-actual-switches "-AGFhlt")
                          (revert-buffer)))))

;; which-key - show possible keybinds
(use-package which-key
    :ensure nil
    :hook
    (after-init . which-key-mode))

;; Projects
;; Tip: run `(project-remember-projects-under "<path>" t)` to discover projects in subdirectories
(use-package project
    :ensure nil
    :custom
    ;; Commands available after 'SPC p p'
    (project-switch-commands '((project-find-file "Find file")
                               (project-find-regexp "Find regexp")
                               (project-find-dir "Find directory")
                               (project-shell "Shell")
                               (my/magit-status "Magit")
                               (project-dired "Root directory")
                               (project-any-command "Other")))
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

    (advice-add 'project-shell :override #'my/project-vterm)

    ;; Detect directories with '.project' file as project roots
    (defgroup project-local nil
        "Local, non-VC-backed project.el root directories."
        :group 'project)

    (defcustom project-local-identifier ".project"
        "You can specify a single filename or a list of names."
        :type '(choice (string :tag "Single file")
                       (repeat (string :tag "Filename")))
        :group 'project-local)

    (cl-defmethod project-root ((project (head local)))
        "Return root directory of current PROJECT."
        (cdr project))

    (defun project-local-try-local (dir)
      "Determine if DIR is a non-VC project. DIR must include a file with the name determined by the variable `project-local-identifier' to be considered a project."
      (if-let ((root (if (listp project-local-identifier)
                         (seq-some (lambda (n)
                                     (locate-dominating-file dir n))
                                   project-local-identifier)
                       (locate-dominating-file dir project-local-identifier))))
          (cons 'local root)))

      (customize-set-variable 'project-find-functions
                              (list #'project-try-vc #'project-local-try-local)))

;; Minibuffer enchancements
(use-package vertico
    :ensure t
    :hook
    (after-init . vertico-mode))

(use-package marginalia
    :ensure t
    :hook
    (after-init . marginalia-mode))

;; Fuzzy, orderless completion
(use-package orderless
    :ensure t
    :custom
    (completion-styles '(substring orderless basic))
    (completion-category-overrides '((file (styles partial-completion))))
    (completion-ignore-case t)
    (read-file-name-completion-ignore-case t)
    (read-buffer-completion-ignore-case t)
    (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex)))

(use-package consult
    :ensure t
    :defer t

    :bind (:map my/leader-map
        ("c t" . consult-theme)
        ("c i" . consult-info)
        ("c o" . consult-outline)
        ("c g" . consult-ripgrep)
        ("c f" . consult-find)
        ("c s" . consult-imenu) ; Consult symbols
        ("c L" . consult-goto-line)
        ("c d" . consult-flymake)
    )

    :custom
    ;; Only show buffers in `consult-buffer`
    (consult-buffer-sources '(consult-source-buffer consult-source-hidden-buffer
                                                    consult-source-modified-buffer
                                                    consult-source-other-buffer)))

(use-package wgrep
    :ensure t)

(use-package embark
    :ensure t
    :bind (:map my/leader-map
        ("e" . embark-act)
    ))

(use-package embark-consult
    :ensure t
    :hook
    (embark-collect-mode . consult-preview-at-point-mode))

;; Completion at point
;; Can be requested by hitting TAB
(use-package corfu
    :ensure t
    :defer t
    :custom
    (corfu-auto t)                        ; Only completes when hitting TAB
    (corfu-auto-delay 0)                ; Delay before popup (enable if corfu-auto is t)
    (corfu-auto-prefix 1)                  ; Trigger completion after typing 1 character
    (corfu-quit-no-match t)                ; Quit popup if no match
    (corfu-scroll-margin 5)                ; Margin when scrolling completions
    (corfu-max-width 50)                   ; Maximum width of completion popup
    (corfu-min-width 50)                   ; Minimum width of completion popup
    (corfu-auto-trigger ".")
    :config
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
    :init
    (global-corfu-mode)
    (corfu-popupinfo-mode t))

;; Vim motions
(use-package evil
    :ensure t
    :hook
    (after-init . evil-mode)

    :bind (
        :map evil-normal-state-map
        ("-" . dired-jump) ; Jump to parent directory
        ("/" . consult-line)

        ;; Make working with line wrap easier
        ("j" . evil-next-visual-line)
        ("k" . evil-previous-visual-line)
        ("$" . evil-end-of-visual-line)
        ("0" . evil-beginning-of-visual-line)

        ("U" . evil-redo) ; Helix-like redo

        :map my/leader-map
        ;; Call commands
        ("/" . execute-extended-command)

        ;; Clipboard
        ("Y" . (lambda () (interactive) (evil-use-register ?+)
                 (call-interactively 'evil-yank)))
        ("P" . (lambda () (interactive) (evil-use-register ?+)
                 (call-interactively 'evil-paste-after)))

        ;; Find stuff
        ("f f" . find-file)
        ("f r" . consult-recent-file)
        ("f l" . find-library)

        ;; Buffers
        ("b b" . consult-buffer)
        ("b i" . ibuffer)
        ("b s" . save-buffer)
        ("b k" . kill-buffer)

        ;; Narrowing
        ("n n" . narrow-to-region)
        ("n w" . widen)

        ;; Remap prefixes to evil leader
        ("h" . help-command)
        ("w" . evil-window-map)

        ;; Commands
        ("&" . async-shell-command)
    )

    :init
    (setq evil-want-keybinding nil)
    (setq evil-want-Y-yank-to-eol t)
    (setq evil-want-fine-undo t)
    (setq evil-leader/in-all-states t)
    (setq evil-disable-insert-state-bindings t)

    :config
    (evil-set-undo-system 'undo-tree)
    (evil-define-key '(normal visual motion) 'global (kbd "SPC") my/leader-map) ; Probably cleaner to use keymaps rather than `evil-set-leader`

    ;; Initial states
    (evil-set-initial-state 'org-agenda-mode 'motion)

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
    (evil-collection-org-setup)
    (evil-collection-setup-minibuffer t))

;; Multicursor
(use-package evil-mc
    :ensure t
    :config
    (global-evil-mc-mode 1)
    (evil-define-key '(normal visual) 'global (kbd "g m") evil-mc-cursors-map))

;; Jump to visible text with keyboard
(use-package avy
    :ensure t
    :bind (:map evil-normal-state-map
        ("s" . avy-goto-word-1)
    ))

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
    (add-to-list 'nerd-icons-extension-icon-alist '("astro" nerd-icons-devicon "nf-dev-astro" :face nerd-icons-orange))
    (add-to-list 'nerd-icons-extension-icon-alist '("typ" nerd-icons-flicon "nf-linux-typst" :face nerd-icons-cyan)))

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

(use-package nerd-icons-corfu
    :ensure t
    :defer t
    :after corfu)

(use-package nerd-icons-grep
    :ensure t)

(use-package nerd-icons-xref
    :ensure t)

(use-package vterm
    :ensure t

    :bind (
        :map my/leader-map
        ("o t" . vterm) ; Open terminal

        :map vterm-mode-map
        ("C-<escape>" . (lambda () (interactive) (vterm-copy-mode)
                          (turn-on-evil-mode)
                          (evil-normal-state)))
    )

    :config
    (setq vterm-timer-delay 0.01)
    (evil-define-key 'normal vterm-copy-mode-map (kbd "i") (lambda () (interactive) (turn-off-evil-mode)
                                                             (vterm-copy-mode -1)
                                                             (setq cursor-type 'bar)))

    :hook
    (vterm-mode . (lambda ()
                    (setq-local global-hl-line-mode nil)
                    (setq-local default-text-properties nil) ; vterm does not like line-spacing
                    (turn-off-evil-mode)
                    )))

;; Treesitter major modes packages
(use-package html-ts-mode
    :ensure nil
    :mode "\\.html\\'")
(use-package c-ts-mode :ensure nil)
(use-package yaml-ts-mode
    :ensure nil
    :mode "\\.ya?ml\\'")
(use-package dockerfile-ts-mode
    :ensure nil
    :mode "\\(?:Dockerfile\\(?:\\..*\\)?\\|\\.[Dd]ockerfile\\)\\'")
(use-package go-ts-mode :ensure nil)
(use-package lua-ts-mode :ensure nil)
(use-package php-ts-mode
    :ensure nil
    :mode "\\.php\\|.phtml\\'")
(use-package heex-ts-mode :ensure nil)
(use-package java-ts-mode :ensure nil)
(use-package json-ts-mode :ensure nil)
(use-package ruby-ts-mode :ensure nil)
(use-package rust-ts-mode :ensure nil)
(use-package toml-ts-mode :ensure nil)
(use-package cmake-ts-mode :ensure nil)
(use-package elixir-ts-mode :ensure nil)
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.jsx\\|.tsx\\'" . tsx-ts-mode)))
(use-package typst-ts-mode
    :ensure t
    :mode "\\.typ\\'")
(use-package astro-ts-mode
    :ensure t
    :mode "\\.astro\\'")
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
        (typst "https://github.com/uben0/tree-sitter-typst")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

;; Remap modes to use Treesitter versions
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))
(add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))
(add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
(add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode))
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))

;; Filename major mode custom associations
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))

;; Markdown
(use-package markdown-mode
    :ensure t
    :mode ("\\.md\\'" . markdown-mode)
    :custom
    (markdown-fontify-code-blocks-natively t)

    :config
    (evil-define-key 'normal markdown-mode-map (kbd "SPC n s") 'markdown-narrow-to-subtree)
    (evil-define-key 'normal markdown-mode-map (kbd "SPC n b") 'markdown-narrow-to-block)

    :hook
    (markdown-mode . (lambda () (markdown-display-inline-images))))

;; Mixed pitch fonts
(use-package mixed-pitch
    :ensure t
    :hook
    (markdown-mode . mixed-pitch-mode)
    (org-mode . mixed-pitch-mode))

;; Center prose buffers
(use-package olivetti
    :ensure t
    :hook
    (markdown-mode . olivetti-mode)
    (org-mode . olivetti-mode)
    (Man-mode . olivetti-mode)
    (Info-mode . olivetti-mode))

;; Nice padding around various UI elements
(use-package spacious-padding
    :ensure t
    :config
    (spacious-padding-mode))

;; Spellchecking
;; jinx is much faster than flyspell
;; Needs 'enchant2-devel' dnf package
(use-package jinx
    :ensure t
    :custom
    (jinx-languages "en_US pl_PL")
    (text-mode-ispell-word-completion nil)
    :hook
    (text-mode . jinx-mode)
    :bind (:map evil-normal-state-map
        ("z=" . jinx-correct)
        ("]s" . jinx-next)
        ("[s" . jinx-previous)
    ))

;; Better PDF viewer
(use-package pdf-tools
    :ensure t
    :defer nil
    :mode ("\\.pdf\\'" . pdf-view-mode)
    :custom
    (large-file-warning-threshold nil) ; PDFs are often large and cause a warning to show up

    :config
    (pdf-tools-install)
    (pdf-loader-install)
    (pdf-virtual-global-minor-mode)

    :hook
    (pdf-view-mode . (lambda ()
                         (setq-local global-hl-line-mode nil)
                         (setq-local default-text-properties nil)
                         (save-place-local-mode)
                         (pdf-view-fit-height-to-window)
                         (pdf-view-themed-minor-mode)
                         (pdf-view-roll-minor-mode)
                         (setq-local evil-default-cursor '(ignore))
                         (setq cursor-type nil)
                         )))

;; Remember page positions in PDFs
(use-package saveplace-pdf-view
    :ensure t
    :after pdf-tools)

(use-package calendar
    :ensure nil
    :custom
    (calendar-week-start-day 1)
    :bind (:map my/leader-map
        ("o c" . calendar)
    ))

(use-package calc
    :ensure nil
    :bind (:map my/leader-map
        ("o C" . calc)
    ))

;; Org
(use-package org
    :ensure nil
    :custom
    (org-M-RET-may-split-line nil)
    (org-log-done 'time)
    (auto-save-visited-predicate (lambda () (and (eq major-mode 'org-mode) (not (epa-file-name-p buffer-file-name)))))
    (org-agenda-files '("~/Documents/org-notes/Notes PG/mgr/"))
    (org-agenda-skip-scheduled-if-done t)
    (org-agenda-custom-commands
        '(("s" "Scheduled TODOs by date"
            agenda ""
            ((org-agenda-entry-types '(:scheduled))
             (org-agenda-start-day "0d")
             (org-agenda-span 'year)
             (org-agenda-show-all-dates nil)
             (org-agenda-scheduled-leaders '(" " ""))
             (org-agenda-overriding-header "Scheduled TODO items")))))

    :bind (:map my/leader-map
        ("o a" . (lambda () (interactive) (org-agenda nil "s")))
    )

    :config
    (auto-save-visited-mode)

    (defun my/org-agenda-switch-to-other-window ()
        "Open current org agenda item in the other window."
        (interactive)
        (let ((marker (or (org-get-at-bol 'org-hd-marker)
                          (org-get-at-bol 'org-marker))))
            (when marker
                (other-window 1)
                (switch-to-buffer (marker-buffer marker))
                (goto-char marker)
                (org-show-context)
                (org-fold-show-siblings)
                (org-fold-show-subtree))))

    ;; Some fixes for evil org agenda
    (evil-define-key 'motion org-agenda-mode-map (kbd "RET") 'my/org-agenda-switch-to-other-window)

    (defun my/org-toggle-task ()
        "Toggle an Org Mode TODO heading or checkbox. Based on 'org-ctrl-c-ctrl-c'."
        (interactive)
        (let* (
            (context (org-element-lineage (org-element-context)
                ;; Limit to supported contexts.
                '(babel-call clock dynamic-block footnote-definition
                    footnote-reference inline-babel-call inline-src-block
                    inlinetask item keyword node-property paragraph
                    plain-list planning property-drawer radio-target
                    src-block statistics-cookie table table-cell table-row
                    timestamp) t))
	        (type (org-element-type context)))

            ;; Go into paragraph
            (when (eq type 'paragraph)
                (let ((parent (org-element-parent context)))
                (when (and (org-element-type-p parent 'item)
                        (= (line-beginning-position)
                        (org-element-begin parent)))
                    (setq context parent)
                    (setq type 'item))))

            (pcase type
                (`item (org-ctrl-c-ctrl-c))
                ((or `headline (and `nil (guard (org-at-heading-p)))) (org-todo)))))

    (evil-define-key 'normal org-mode-map (kbd "SPC n s") 'org-narrow-to-subtree)
    (evil-define-key 'normal org-mode-map (kbd "SPC n b") 'org-narrow-to-block)

    (evil-define-key 'normal org-mode-map (kbd "SPC l") 'org-latex-preview)

    (evil-define-key 'normal org-mode-map (kbd "SPC t") 'my/org-toggle-task)
    (evil-define-key 'normal org-mode-map (kbd "SPC T") (lambda () (interactive)
                                                          (insert "** ")
                                                          (org-insert-timestamp (current-time)))))

(use-package ox-typst
    :ensure t)

(use-package org-tempo
    :ensure nil)

;; Org babel languages
(use-package ob-python :after org)
(use-package ob-lua :after org)
(use-package ob-gnuplot :after org)

;; Http requests from Org source blocks
(use-package verb
    :ensure t
    :after org
    :config
    (org-babel-do-load-languages
        'org-babel-load-languages
        '((verb . t))))

;; Typst
(use-package websocket
    :ensure t)

(use-package typst-preview
    :ensure t
    :custom
    (typst-preview-invert-colors "never"))

;; Evil-like transient quit (mainly for magit)
(use-package transient
    :ensure t
    :bind (:map transient-map
        ("<escape>" . transient-quit-one)
        ("C-<escape>" . transient-quit-all)
    ))

(use-package magit
    :ensure t
    :custom
    (magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
    (magit-section-initial-visibility-alist '((stashes . hide) (unpushed . show)))
    (magit-format-file-function 'magit-format-file-nerd-icons)
    :bind (:map my/leader-map
        ("p m" . my/magit-status)
    )
    :config
    (keymap-unset magit-status-mode-map "SPC")
    (defun my/magit-status ()
        "Like 'magit-status' but respect 'project-current-directory-override'."
        (interactive)
        (if project-current-directory-override
            (magit-status project-current-directory-override)
            (magit-status))))

(use-package gnome-accent-theme-switcher
    :vc (:url "https://github.com/protesilaos/gnome-accent-theme-switcher.git"
         :rev "f1f20081f15b67f176273100dab1a940b3ecc840")

    :custom
    (gnome-accent-theme-switcher-collection '(("blue"
                                               :light (ef-maris-light ef-deuteranopia-light)
                                               :dark  (ef-night ef-deuteranopia-dark ef-dark ef-duo-dark doric-mermaid standard-dark-tinted))
                                              ("teal"
                                               :light (ef-spring ef-frost doric-wind doric-jade)
                                               :dark  (ef-maris-dark doric-valley))
                                              ("green"
                                               :light (ef-cyprus)
                                               :dark  (ef-bio))
                                              ("yellow"
                                               :light (ef-melissa-light ef-duo-light ef-eagle doric-earth)
                                               :dark  (ef-melissa-dark))
                                              ("orange"
                                               :light (ef-orange ef-day doric-beach)
                                               :dark  (ef-autumn doric-copper))
                                              ("red"
                                               :light (modus-operandi-tinted standard-light-tinted ef-tritanopia-light ef-arbutus)
                                               :dark  (ef-tritanopia-dark doric-fire))
                                              ("pink"
                                               :light (ef-summer ef-reverie doric-cherry ef-kassio)
                                               :dark  (ef-cherie ef-rosa))
                                              ("purple"
                                               :light (ef-trio-light ef-light doric-siren)
                                               :dark  (ef-trio-dark ef-winter ef-fig ef-dream doric-plum))
                                              ("slate"
                                               :light (doric-marble doric-light)
                                               :dark  (ef-owl doric-obsidian doric-water doric-dark))))

    :config
    (gnome-accent-theme-switcher-mode))

(use-package gptel
    :ensure t

    :bind (:map my/leader-map
        ("o g" . (lambda () (interactive) (switch-to-buffer (gptel "*Ollama*"))))
    )

    :config
    (setq gptel-model 'mistral:latest)
    (setq gptel-backend (gptel-make-ollama "Ollama"
                       :host "localhost:11434"
                       :stream t
                       :models '(mistral:latest SpeakLeash/bielik-4.5b-v3.0-instruct:Q8_0))))

(use-package artist
    :ensure nil
    :config
    (defvar my/artist-buffer-name
        "*Drawing*"
        "Name of the 'artist-mode' buffer created by 'my/artist-new-buffer'.")

    (defun my/artist-new-buffer ()
        "Creates a new *Drawing* buffer and starts 'artist-mode'."
        (interactive)
        (let* (
                  (new-drawing (eq (get-buffer my/artist-buffer-name) nil))
                  (drawing-buffer (get-buffer-create my/artist-buffer-name)))
            (switch-to-buffer drawing-buffer)
            (when new-drawing
                (setq-local global-hl-line-mode nil)
                (setq-local default-text-properties nil)
                (turn-off-evil-mode)
                (artist-mode)))))

(use-package epa
    :ensure nil
    :custom
    (epg-pinentry-mode 'loopback)
    (epa-file-select-keys 'no))

(use-package nov
    :ensure t
    :mode ("\\.epub\\'" . nov-mode)
    :custom
    (nov-text-width 70)
    :hook
    (nov-mode . (lambda () (setq-local global-hl-line-mode nil)
                           (olivetti-mode)
                           (setq-local olivetti-body-width 80)
                           (scroll-lock-mode))))

(use-package docker
    :ensure t
    :custom
    (docker-compose-command "docker compose")
    :bind (:map my/leader-map
        ("o d" . docker)
    ))
