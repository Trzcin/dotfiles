;; -*- eval: (outline-minor-mode); -*-

;;; Customize file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;; Private file
(load (locate-user-emacs-file "private.el") 'noerror 'nomessage)

;;; Package manager
(use-package use-package
    :custom
    ;; use-package lazy loading stats: 'use-package-report'
    (use-package-compute-statistics t))

(use-package package
    :init
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;; General Emacs settings
(setq inhibit-startup-echo-area-message "trzcin")

(use-package emacs
    :custom
    ;; Disable autosave, backups, lockfiles etc.
    (auto-save-default nil)
    (auto-save-list-file-prefix nil)
    (create-lockfiles nil)
    (make-backup-files nil)

    (global-auto-revert-non-file-buffers t)

    ;; Indentation
    (indent-tabs-mode nil)
    (evil-shift-width 4)
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

    ;; Line and column numbers
    (display-line-numbers-width 3)

    ;; Scrolling
    (pixel-scroll-precision-mode t)
    (scroll-conservatively 101)

    (ring-bell-function 'ignore)

    (custom-safe-themes t)
    (switch-to-buffer-obey-display-actions t)
    (treesit-font-lock-level 4)
    (truncate-lines t)
    (use-dialog-box nil)
    (use-short-answers t)
    (frame-title-format "%b")
    (help-window-select t)
    (help-window-keep-selected t)
    (enable-recursive-minibuffers t)
    (inhibit-startup-screen t)
    (server-client-instructions nil)
    (browse-url-browser-function 'browse-url-xdg-open)
    (find-library-include-other-files nil)

    :hook
    (prog-mode . (lambda () (display-line-numbers-mode)
                            (setq show-trailing-whitespace t)))
    (text-mode . (lambda () (visual-line-mode)
                            (setq show-trailing-whitespace t)))
    (astro-ts-mode . display-line-numbers-mode)
    (typst-ts-mode . display-line-numbers-mode)
    (html-ts-mode . display-line-numbers-mode)
    (yaml-ts-mode . display-line-numbers-mode)
    (conf-mode . display-line-numbers-mode)

    :init
    (global-hl-line-mode)
    (global-auto-revert-mode)
    (recentf-mode)
    (savehist-mode)
    (file-name-shadow-mode)

    (defvar-keymap my/leader-map)

    ;; Encoding system
    (modify-coding-system-alist 'file "" 'utf-8)
    (add-to-list 'file-coding-system-alist '("\\.\\(?:png\\|jpg\\|jpeg\\|gif\\|webp\\|bmp\\)\\'" . raw-text))

    (put 'narrow-to-region 'disabled nil))

(use-package isearch
    :custom
    (search-whitespace-regexp ".*?")
    (isearch-lax-whitespace t)
    (isearch-regexp-lax-whitespace nil)
    (isearch-lazy-count t)
    (lazy-count-prefix-format "(%s/%s) ")
    (lazy-count-suffix-format nil))

;;; Buffer display
(add-to-list 'display-buffer-alist
    '((or . ((derived-mode . occur-mode)
             (derived-mode . grep-mode)
             (derived-mode . help-mode)))
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (body-function . select-window)))

;;; Appearence
;;;; Frame settings
(setq default-frame-alist '((undecorated . t) (fullscreen . maximized)))

;;;; Disable some UI elements
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(fringe-mode 0)

;;;; Fonts
(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 120)
(set-face-attribute 'fixed-pitch nil :family "JetBrainsMono Nerd Font" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Inter" :height 1.0)
(setq default-text-properties '(line-spacing 0.125 line-height 1.125)) ; NOTE: with Emacs 31 there should be a cleaner way to do this

;;;; Themes
(use-package spacious-padding
    :ensure t
    :config
    (spacious-padding-mode))

(use-package ef-themes
    :ensure t
    :config
    (setq ef-themes-mixed-fonts t)
    (setq ef-themes-headings '((0 . (2.0))
                               (1 . (2.0))
                               (2 . (1.7))
                               (3 . (1.4))
                               (4 . (1.1))))
    (ef-themes-load-theme 'ef-bio))

(use-package gnome-accent-theme-switcher
    :vc (:url "https://github.com/protesilaos/gnome-accent-theme-switcher.git"
         :rev "b5c5b5b29234d18bfdd9e9142137a453e07e79e2")
    :config
    (setf (alist-get "green" gnome-accent-theme-switcher-collection nil nil #'equal)
        '(:light (ef-cyprus) :dark (ef-bio)))
    (gnome-accent-theme-switcher-mode))

;;;; Modeline
;; Cache values
;; This is done for performance reasons, especially with TRAMP
(defvar-local my/modeline--project nil)
(defvar-local my/modeline--project-root nil)
(defvar-local my/modeline--vc-branch nil)

(defun my/modeline-reset-cache ()
    "Reset all cache variables and compute them again"
    (setq my/modeline--project nil)
    (setq my/modeline--project-root nil)
    (setq my/modeline--vc-branch nil))

(add-hook 'find-file-hook 'my/modeline-reset-cache)
(add-hook 'after-save-hook 'my/modeline-reset-cache)

(defun my/modeline--project-root ()
    (or my/modeline--project-root
        (setq my/modeline--project-root
            (when (and (not (file-remote-p default-directory)) (project-current nil))
                (project-root (project-current nil))))))

(defun my/modeline--project ()
    (or my/modeline--project
        (setq my/modeline--project
            (when-let ((root (my/modeline--project-root)))
                (let ((proj (project-current nil)))
                    (list (project-name proj) root))))))

(defun my/modeline--vc-branch ()
    (or my/modeline--vc-branch
        (setq my/modeline--vc-branch
            (when (and buffer-file-name (not (file-remote-p buffer-file-name)))
                (when-let* ((backend (vc-backend buffer-file-name))
                            (rev (vc-working-revision buffer-file-name backend)))
                    (or (vc-git--symbolic-ref buffer-file-name)
                        (substring rev 0 7)))))))

(defvar-local my/mode-line-narrow
    '(:eval (when (and (mode-line-window-selected-p) (buffer-narrowed-p))
                (propertize " Narrow " 'face '(:inherit mode-line-highlight :box nil))))
    "Displays if the buffer is narrowed")
(put 'my/mode-line-narrow 'risky-local-variable t)

(defvar-local my/mode-line-buffer-icon
    '(:eval (nerd-icons-icon-for-buffer :face (if (mode-line-window-selected-p)
                                                  'mode-line-active
                                                  'mode-line-inactive)))
    "Icon for the buffer.")
(put 'my/mode-line-buffer-icon 'risky-local-variable t)

(defvar-local my/mode-line-buffer-name
    '(:eval
         (cond
             ((and buffer-file-name (not (file-remote-p buffer-file-name)) (my/modeline--project-root))
                  (file-relative-name buffer-file-name (my/modeline--project-root)))
             (buffer-file-truename buffer-file-truename)
             (t "%b")))
    "Name of the current buffer or file path.")
(put 'my/mode-line-buffer-name 'risky-local-variable t)

(defvar-local my/mode-line-buffer-status
    '(:eval (cond (buffer-read-only " ")
                  ((buffer-modified-p) " 󰆓")
                  (t "")))
    "Visual representation of the buffer status.")
(put 'my/mode-line-buffer-status 'risky-local-variable t)

(defvar-local my/mode-line-major-mode
    '(:eval (string-replace "-" " " (capitalize (symbol-name major-mode))))
    "Pretty major mode name.")
(put 'my/mode-line-major-mode 'risky-local-variable t)

(defvar-local my/mode-line-project
    '(:eval
         (when-let* (((mode-line-window-selected-p))
                     (proj (my/modeline--project)))
             (let ((name (car proj))
                   (dir (cadr proj)))
                 (list
                     "  "
                     (nerd-icons-icon-for-dir dir :face 'mode-line-active)
                     " "
                     name))))
    "Name of the current project")
(put 'my/mode-line-project 'risky-local-variable t)

(defvar-local my/mode-line-vc-branch
    '(:eval
         (when-let* (((mode-line-window-selected-p))
                     (branch (my/modeline--vc-branch)))
             (format " %s" branch)))
    "VC branch segment.")
(put 'my/mode-line-vc-branch 'risky-local-variable t)

(defvar-local my/mode-line-text-pos
    '(:eval (list "L: %l/"
                  (number-to-string (line-number-at-pos (point-max)))
                  "  "
                  "C: %c"))
    "Point line and column position string for the modeline.")
(put 'my/mode-line-text-pos 'risky-local-variable t)

(defvar-local my/mode-line-pdf-pos
    '(:eval (format "P: %d/%d"
                    (pdf-view-current-page)
                    (pdf-cache-number-of-pages)))
    "Current page and total page number display in PDF buffers.")
(put 'my/mode-line-pdf-pos 'risky-local-variable t)

(defvar-local my/flymake--mode-line-counter-cache nil)

(defun my/flymake--mode-line-counter-1 (type sign)
  (let ((count 0)
        (face (flymake--lookup-type-property type
                                             'mode-line-face
                                             'compilation-error)))
    (dolist (d (flymake-diagnostics))
      (when (= (flymake--severity type)
               (flymake--severity (flymake-diagnostic-type d)))
        (cl-incf count)))
    (when (or (cl-plusp count)
              (cond ((eq flymake-suppress-zero-counters t)
                     nil)
                    (flymake-suppress-zero-counters
                     (>= (flymake--severity type)
                         (warning-numeric-level
                          flymake-suppress-zero-counters)))
                    (t t)))
          (format "%s%s" sign count))))

(defun my/flymake--mode-line-counter (type sign)
  "Compute numb SIGN er of diagnostics in buffer with TYPE's severity.
TYPE is usually keyword `:error', `:warning' or `:note'."
  (let ((probe (alist-get type my/flymake--mode-line-counter-cache 'none)))
    (if (eq probe 'none)
        (setf (alist-get type my/flymake--mode-line-counter-cache)
            (my/flymake--mode-line-counter-1 type sign))
      probe)))

;; Reset cache when diagnostics change
(advice-add 'flymake--publish-diagnostics :after (lambda (&rest _) (setq my/flymake--mode-line-counter-cache nil)))

(defvar-local my/mode-line-diagnostics
    '(:eval (when (and (mode-line-window-selected-p) (bound-and-true-p flymake-mode) (flymake-running-backends))
                (let* ((error-sign (cl-first (alist-get 'error flymake-margin-indicators-string)))
                       (warn-sign (cl-first (alist-get 'warning flymake-margin-indicators-string)))
                       (note-sign (cl-first (alist-get 'note flymake-margin-indicators-string))))
                    (s-join " "
                        (list
                            (my/flymake--mode-line-counter :error error-sign)
                            (my/flymake--mode-line-counter :warning warn-sign)
                            (my/flymake--mode-line-counter :note note-sign)
                         )
                        ))))
    "Display buffer diagnostic counters.")
(put 'my/mode-line-diagnostics 'risky-local-variable t)

(defvar-local my/mode-line-pos
    '(:eval (when (mode-line-window-selected-p)
                (if (eq major-mode 'pdf-view-mode)
                    my/mode-line-pdf-pos
                    my/mode-line-text-pos)))
    "General position dependant on the major mode.")
(put 'my/mode-line-pos 'risky-local-variable t)

(setq-default mode-line-format
    '(""
      my/mode-line-narrow
      " "
      my/mode-line-buffer-icon
      " "
      my/mode-line-buffer-name
      my/mode-line-buffer-status
      "  "
      my/mode-line-major-mode
      my/mode-line-project
      "  "
      my/mode-line-vc-branch

      mode-line-format-right-align

      my/mode-line-diagnostics
      "  "
      my/mode-line-pos
      " "))

;;;; Welcome screen
;; Based on 'https://xenodium.com/bending-emacs-episode-2'
(defun my/show-welcome-buffer ()
    (interactive)
    "Show *Welcome* buffer."
    (switch-to-buffer (my/get-welcome-buffer)))

(defun my/get-welcome-buffer ()
    "Get or create *Welcome* buffer."
    (with-current-buffer (get-buffer-create "*Welcome*")
        (setq truncate-lines t)
        (setq-local evil-default-cursor '(ignore))
        (setq cursor-type nil)
        (setq-local global-hl-line-mode nil)
        (setq-local default-text-properties nil)
        (read-only-mode)
        (my/refresh-welcome-buffer)
        (add-hook 'window-size-change-functions
            (lambda (_frame)
                (my/refresh-welcome-buffer)) nil t)
        (add-hook 'window-configuration-change-hook
            #'my/refresh-welcome-buffer nil t))
    (get-buffer "*Welcome*"))

(defun my/refresh-welcome-buffer ()
    "Refresh welcome buffer content for WINDOW."
    (when-let* (((display-graphic-p))
                (inhibit-read-only t)
                (welcome-buffer (get-buffer "*Welcome*"))
                (window (get-buffer-window welcome-buffer))
                (image-path "~/.config/emacs/assets/sugarcane.png")
                (image (create-image image-path nil nil))
                (image-height (cdr (image-size image)))
                (image-width (car (image-size image)))
                (top-margin (floor (/ (- (window-height window) image-height) 2)))
                (left-margin (floor (/ (- (window-width window) image-width) 2)))
                (title (format "Welcome to Emacs %s!" user-full-name)))
        (with-current-buffer welcome-buffer
            (erase-buffer)
            (setq mode-line-format nil)
            (goto-char (point-min))
            (insert (make-string top-margin ?\n))
            (insert (make-string left-margin ?\ ))
            (insert-image image)
            (insert "\n\n")
            (insert (make-string (- (floor (/ (- (window-width window) (string-width title)) 2)) 1) ?\ ))
            (insert (propertize title 'face '(:inherit variable-pitch :height 1.2 :weight bold))))))

;; Show dashboard in new frames
(setq initial-buffer-choice 'my/get-welcome-buffer)

;; Clear minibuffer in new frames
(add-hook 'server-after-make-frame-hook (lambda () (message "")))

;;; Dired file manager
(use-package dired
    :custom
    (dired-recursive-copies 'always)
    (dired-recursive-deletes 'always)
    (delete-by-moving-to-trash t)
    (dired-listing-switches "-AGFhlv --group-directories-first")
    (dired-dwim-target t)
    (dired-auto-revert-buffer 'dired-directory-changed-p)
    (dired-kill-when-opening-new-dired-buffer t)
    (dired-compress-directory-default-suffix ".zip")
    (dired-free-space nil)
    (dired-omit-files "^[.].+$")
    (dired-create-destination-dirs 'ask)
    (dired-create-destination-dirs-on-trailing-dirsep t)

    :hook
    (dired-mode . (lambda () (dired-hide-details-mode)
                      (evil-local-set-key 'normal (kbd "s h") 'dired-omit-mode)
                      ;; Sort Downloads directory by time
                      (when (and (stringp dired-directory)
                                 (string= dired-directory "~/Downloads/"))
                          (setq-local dired-actual-switches "-AGFhlt")
                          (revert-buffer)))))

;; Easy Trash directory manipulation (any OS)
(use-package trashed
    :ensure t)

(use-package dired-preview
    :ensure t
    :after dired
    :custom
    (dired-preview-delay 0)
    :config
    :hook
    (dired-mode . (lambda () (evil-local-set-key 'normal (kbd "s p") 'dired-preview-mode))))

(use-package dwim-shell-command
    :ensure t
    :defer nil
    :bind (([remap shell-command] . dwim-shell-command)
           :map dired-mode-map
           ([remap dired-do-async-shell-command] . dwim-shell-command)
           ([remap dired-do-shell-command] . dwim-shell-command)
           ([remap dired-smart-shell-command] . dwim-shell-command))
    :config
    (defun my/merge-pdfs ()
        "Merge all marked pdfs into one file."
        (interactive)
        (when-let* ((output-file (expand-file-name (read-file-name "Output PDF: "))))
            (dwim-shell-command-on-marked-files
                "Merge PDFs"
                (format "pdfunite <<*>> '%s'" output-file)
                :extensions "pdf"
                :utils "pdfunite"))))

;;; Minibuffer and completion at point
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
    (completion-category-defaults nil)
    (completion-styles '(substring orderless basic))
    (completion-category-overrides '((file (styles partial-completion))))
    (completion-ignore-case t)
    (read-file-name-completion-ignore-case t)
    (read-buffer-completion-ignore-case t)
    (orderless-matching-styles '(orderless-literal orderless-regexp orderless-flex)))

(use-package consult
    :ensure t
    :defer t
    :config
    (defun my/consult-grep ()
        "Call 'consult-ripgrep' if possible, fallback to 'consult-grep' otherwise."
        (interactive)
        (if (executable-find "rg" t)
            (consult-ripgrep)
            (consult-grep)))

    :bind (:map my/leader-map
        ("c t" . consult-theme)
        ("c i" . consult-info)
        ("c o" . consult-outline)
        ("c g" . my/consult-grep)
        ("c f" . consult-find)
        ("c s" . consult-imenu)
        ("c L" . consult-goto-line)
        ("c d" . consult-flymake)
    )

    :custom
    ;; Only show buffers in `consult-buffer`
    (consult-buffer-sources '(consult-source-buffer
                              consult-source-hidden-buffer
                              consult-source-modified-buffer
                              consult-source-other-buffer)))

(use-package wgrep :ensure t)

(use-package embark
    :ensure t
    :custom
    (prefix-help-command #'embark-prefix-help-command)
    :bind (:map my/leader-map
        ("e" . embark-act)
    ))

(use-package embark-consult
    :ensure t
    :hook
    (embark-collect-mode . consult-preview-at-point-mode))

;; Completion at point
(use-package corfu
    :ensure t
    :defer t
    :custom
    (corfu-auto t)
    (corfu-auto-delay 0.01)
    (corfu-auto-prefix 1)
    (corfu-quit-no-match t)
    (corfu-scroll-margin 5)
    (corfu-max-width 50)
    (corfu-min-width 50)
    (corfu-auto-trigger ".")
    :config
    (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
    (keymap-unset corfu-map "RET")
    :init
    (global-corfu-mode)
    (corfu-popupinfo-mode t))

;;; Vim motions
(use-package evil
    :ensure t
    :hook
    (after-init . evil-mode)

    :bind (
        :map evil-normal-state-map
        ("-" . dired-jump)
        ("/" . consult-line)

        ;; Make working with line wrap easier
        ("j" . evil-next-visual-line)
        ("k" . evil-previous-visual-line)

        ("U" . evil-redo)

        :map evil-visual-state-map
        ("/" . (lambda () (interactive) (let* ((initial (buffer-substring (region-beginning) (region-end))))
                                              (consult-line initial))))

        :map my/leader-map
        ("/" . execute-extended-command)

        ;; System clipboard access
        ("Y" . (lambda () (interactive) (evil-use-register ?+)
                 (call-interactively 'evil-yank)))
        ("P" . (lambda () (interactive) (evil-use-register ?+)
                 (call-interactively 'evil-paste-after)))

        ;; Find ____
        ("f f" . find-file)
        ("f F" . find-function)
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
    )

    :init
    (setq evil-want-keybinding nil)
    (setq evil-want-Y-yank-to-eol t)
    (setq evil-want-fine-undo t)
    (setq evil-leader/in-all-states t)
    (setq evil-disable-insert-state-bindings t)
    (setq select-enable-clipboard nil)

    :config
    (evil-set-undo-system 'undo-tree)
    (evil-define-key '(normal visual motion) 'global (kbd "SPC") my/leader-map)

    ;; Initial states
    (evil-set-initial-state 'org-agenda-mode 'motion)

    ;; Replace
    (evil-define-key '(normal visual) 'global (kbd "?") 'query-replace-regexp)

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
    (evil-collection-key-blacklist '("SPC"))
    (evil-collection-org-setup)
    (evil-collection-setup-minibuffer t))

(use-package evil-numbers
    :ensure t
    :after evil

    :bind (:map evil-normal-state-map
        ("g =" . evil-numbers/inc-at-pt)
        ("g -" . evil-numbers/dec-at-pt)

        :map evil-visual-state-map
        ("g =" . evil-numbers/inc-at-pt-incremental)
        ("g -" . evil-numbers/dec-at-pt-incremental)
    ))

(use-package evil-mc
    :ensure t
    :config
    (global-evil-mc-mode 1)
    (evil-define-key '(normal visual) 'global (kbd "g m") evil-mc-cursors-map))

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
    (undo-tree-history-directory-alist '(("." . "~/.config/emacs/undotree"))))

;;; Icons
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

;;; Prose editing
;;;; General settings
(use-package olivetti ; Center prose buffers
    :ensure t
    :hook
    (markdown-mode . olivetti-mode)
    (org-mode . olivetti-mode)
    (Man-mode . olivetti-mode)
    (Info-mode . olivetti-mode))

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
    (yaml-ts-mode . (lambda () (jinx-mode -1)))
    (html-mode . (lambda () (jinx-mode -1)))
    :bind (:map evil-normal-state-map
        ("z=" . jinx-correct)
        ("]s" . jinx-next)
        ("[s" . jinx-previous)
    ))

(use-package epa-file)
(use-package epa
    :custom
    (epa-file-select-keys 'no))

;;;; Markdown
(use-package markdown-mode ; Once Emacs 31 comes out, I could use the new builtin 'markdown-ts-mode'
    :ensure t
    :mode ("\\.md\\'" . markdown-mode)
    :custom
    (markdown-fontify-code-blocks-natively t)
    :config
    (evil-define-key 'normal markdown-mode-map (kbd "SPC n s") 'markdown-narrow-to-subtree)
    (evil-define-key 'normal markdown-mode-map (kbd "SPC n b") 'markdown-narrow-to-block)
    :hook
    (markdown-mode . (lambda () (variable-pitch-mode)
                         (markdown-display-inline-images))))

;;;; Org
(use-package org
    :defer t
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

    :hook
    (org-mode . (lambda ()
                    (variable-pitch-mode)
                    (setq-local paragraph-start "\\|[ 	]*$")
                    (setq-local paragraph-separate "[ 	]*$")
                    ))

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
                (save-excursion
                    (when (org-up-heading-safe)
                        (org-fold-show-entry)))
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
    :ensure t
    :after org)

(use-package org-tempo :after org)

;;;; Journal
(defvar my/journal-dir
    "~/Documents/org-notes/Journal"
    "The directory in which journal entries will be stored.")

(defun my/journal-create-or-edit-todays-entry ()
    "Switches to todays journal file if it exists or creates one if needed."
    (interactive)
    (let*
        ((journal-file (file-name-concat my/journal-dir (format-time-string "%Y-%m-%d-dziennik.org.gpg"))))
        (find-file journal-file)
        (when (not (file-exists-p journal-file))
            (insert "#+title: Dziennik\n")
            (insert "#+date: ")
            (org-insert-timestamp (current-time) t)
            (newline 2))))

;;; PDFs
(use-package pdf-tools
    :ensure t
    :pin melpa
    :mode ("\\.pdf\\'" . pdf-view-mode)
    :custom
    (large-file-warning-threshold nil) ; PDFs are often large and cause a warning to show up
    :config
    (pdf-tools-install)
    (pdf-loader-install)
    :hook
    (pdf-view-mode . (lambda ()
                         (setq-local global-hl-line-mode nil)
                         (setq-local default-text-properties nil)
                         (save-place-local-mode)
                         (pdf-view-fit-page-to-window)
                         (pdf-view-themed-minor-mode)
                         (setq-local evil-default-cursor '(ignore))
                         (setq cursor-type nil)
                         )))

(use-package saveplace-pdf-view
    :ensure t)

;;; Utilities
(use-package calendar
    :defer t
    :custom
    (calendar-week-start-day 1)
    :bind (:map my/leader-map
        ("o c" . calendar)
    ))

(use-package calc
    :defer t
    :bind (:map my/leader-map
        ("o C" . calc)
    ))

(use-package man
    :defer t
    :custom
    (Man-support-remote-systems t))

(use-package artist
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

(use-package proced
    :custom
    (proced-enable-color-flag t)
    (proced-format '(user pid tree pcpu rss start time (args comm))))

;;;; Enauczanie
(defvar my/enauczanie-course-list '(
                                    ("Angielski" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=3592")
                                    ("Metody badawcze w informatyce" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=3945")
                                    ("Badania operacyjne - liniowe" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4941")
                                    ("Badania operacyjne - kolejki" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=5005")
                                    ("Niezawodność systemów sieciowych" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=5158")
                                    ("Podstawy analizy rynków kapitałowych" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4686")
                                    ("Sieci Ethernet" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4229")
                                    ("Sieciowe systemy operacyjne" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4074")
                                    ("Systemy obliczeniowe wysokiej wydajności" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4831")
                                    ("Zarządzanie środowiskiem chmurowym" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4151")
                                    ("Zespołowy projekt badawczy" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4323"))
    "List of enauczanie courses with the respective URLs")

(defun my/enauczanie-goto-course ()
    "Prompt for a course and open it in a web browser"
    (interactive)
    (when-let* ((course (completing-read "Wybierz kurs: " (mapcar 'car my/enauczanie-course-list) nil t))
                (url (cdr (assoc course my/enauczanie-course-list))))
                (browse-url-xdg-open url)))

;;; Terminals
;; TODO - replace with 'ghostel'
(use-package vterm
    :ensure t
    :bind (
        :map my/leader-map
        ("o t" . vterm)
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

(use-package eshell
    :bind (:map my/leader-map
        ("o e" . eshell)
    )
    :hook
    (eshell-mode . (lambda () (setq-local global-hl-line-mode nil)))
    :config
    (defun eshell/c ()
        "Alias for `clear t` in eshell."
        (interactive)
        (eshell/clear t)))

;;; Programming
;;;; Projects
;; Tip: run `(project-remember-projects-under "<path>" t)` to discover projects in subdirectories
(use-package project
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
    ;; This is probably buggy
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

;;;; Treesitter
(use-package html-ts-mode :mode "\\.html\\'")
(use-package yaml-ts-mode :mode "\\.ya?ml\\'")
(use-package dockerfile-ts-mode :mode "\\(?:Dockerfile\\(?:\\..*\\)?\\|\\.[Dd]ockerfile\\)\\'")
(use-package php-ts-mode :mode "\\.php\\|.phtml\\'")
(use-package typescript-ts-mode :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.jsx\\|.tsx\\'" . tsx-ts-mode)))
(use-package rust-ts-mode :mode "\\.rs\\'")
(use-package java-ts-mode :mode "\\.java\\'")
(use-package json-ts-mode :mode "\\.json\\'")
(use-package toml-ts-mode :mode "\\.toml\\'")

(use-package typst-ts-mode
    :ensure t
    :mode "\\.typ\\'"
    :config
    (defun my/typst-start-preview ()
        "Start Typst preview in a web browser using the tinymist LSP."
        (interactive)
        (when-let* ((server (eglot-current-server)))
            (eglot-execute
                server
                '(:title "Start Preview"
                  :command "tinymist.doStartBrowsingPreview"
                  :arguments [["--data-plane-host=127.0.0.1:0"
                               "--invert-colors=never"
                               "--open"]])))))

(use-package astro-ts-mode
    :ensure t
    :mode "\\.astro\\'")
(use-package svelte-ts-mode
    :vc (:url "https://github.com/leafOfTree/svelte-ts-mode.git"
         :rev "b1b5b4a5b09493063394a51d0f0f022645a18444")
    :mode "\\.svelte\\'")
(use-package vue-ts-mode
    :vc (:url "https://github.com/theschmocker/vue-ts-mode.git"
         :rev "b1ba7195917cda08ffeac797e14bac0353c1dbe7")
    :mode "\\.vue\\'")

;; Remap builtin modes to use Treesitter versions
;; This can be simplified in Emacs 31
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(cmake-mode . cmake-ts-mode))
(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))
(add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))
(add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))
(add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode))
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode))

;; Where to get Treesitter grammars
;; This can be simplified in Emacs 31
(setq treesit-language-source-alist
      '((dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
        (astro "https://github.com/virchau13/tree-sitter-astro")
        (vue "https://github.com/ikatyang/tree-sitter-vue")
        (svelte "https://github.com/tree-sitter-grammars/tree-sitter-svelte")
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src")
        (typst "https://github.com/uben0/tree-sitter-typst")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

;; Filename major mode custom associations
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-ts-mode)) ; CUDA C
(add-to-list 'auto-mode-alist '("\\isyncrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.prettierrc\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.env\\'" . conf-unix-mode))

;;;; LSP
(use-package eglot
    :config
    (add-to-list 'eglot-server-programs '(html-ts-mode . ("vscode-html-language-server" "--stdio")))
    (add-to-list 'eglot-server-programs '(typst-ts-mode . ("tinymist")))
    (add-to-list 'eglot-server-programs '(svelte-ts-mode . ("svelteserver" "--stdio")))
    :hook
    (c-ts-mode . eglot-ensure)
    (c++-ts-mode . eglot-ensure)
    (rust-ts-mode . eglot-ensure)
    (html-ts-mode . eglot-ensure)
    (css-ts-mode . eglot-ensure)
    (js-ts-mode . eglot-ensure)
    (typescript-ts-mode . eglot-ensure)
    (tsx-ts-mode . eglot-ensure)
    (yaml-ts-mode . eglot-ensure)
    (typst-ts-mode . eglot-ensure)
    (svelte-ts-mode . eglot-ensure)
    :bind (:map my/leader-map
        ("l r" . eglot-rename)
        ("l a" . eglot-code-actions)
        ("l f" . eglot-format-buffer)
    ))

(use-package eldoc-box
    :ensure t
    :after evil
    :custom
    (eldoc-echo-area-use-multiline-p nil)
    :config
    (evil-define-key 'normal 'eglot-mode-map (kbd "K") 'eldoc-box-help-at-point))

(use-package yasnippet
    :ensure t
    :init
    (yas-global-mode))

(use-package flymake
    :config
    (put 'flymake-error 'flymake-margin-string (alist-get 'error flymake-margin-indicators-string))
    (put 'flymake-warning 'flymake-margin-string (alist-get 'warning flymake-margin-indicators-string))
    (put 'flymake-note 'flymake-margin-string (alist-get 'note flymake-margin-indicators-string))
    :custom
    (flymake-indicator-type 'margins)
    (flymake-suppress-zero-counters t)
    (flymake-margin-indicators-string
        `((error " " compilation-error)
          (warning " " compilation-warning)
             (note " " compilation-info)))
    (flymake-show-diagnostics-at-end-of-line t)
    :bind (:map evil-normal-state-map
        ("]d" . flymake-goto-next-error)
        ("[d" . flymake-goto-prev-error)
    ))

;;;; Git
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

(use-package transient
    :ensure t
    :defer t
    :bind (:map transient-map
        ("<escape>" . transient-quit-one)
        ("C-<escape>" . transient-quit-all)
    ))

(use-package diff
    :defer t
    :custom
    (diff-font-lock-syntax nil))

(use-package ediff
    :defer t
    :custom
    (ediff-split-window-function 'split-window-horizontally)
    (ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package diff-hl
    :ensure t
    :custom
    (diff-hl-draw-borders nil)
    (diff-hl-update-async t)
    :bind (
        :map evil-normal-state-map
        ("[g" . diff-hl-previous-hunk)
        ("]g" . diff-hl-next-hunk)
        :map my/leader-map
        ("gs" . diff-hl-show-hunk))
    :init
    (global-diff-hl-mode)
    (diff-hl-flydiff-mode)
    (with-eval-after-load 'magit
        (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

(defvar my/git-clone-list-repo-urls-cmd
    "gh repo list -L 100 --json sshUrl -q '.[] | .sshUrl'"
    "Command to list git ssh clone urls of user owned repositories.")

(defvar my/git-clone-base-dir
    "~/projects/"
    "Directory that should hold cloned repositories.")

(defun my/git-clone ()
    "Git clone"
    (interactive)
    (when-let* ((copied (or (evil-get-register ?+ t) ""))
                (clone-urls (s-split "\n" (shell-command-to-string my/git-clone-list-repo-urls-cmd) t))
                (clone-urls (if (or (string-match-p "^\\(?:http\\|https\\|ssh\\|git\\)://" copied)
                                    (string-match-p "^git@" copied))
                                (cons copied clone-urls)
                                clone-urls))
                (clone-url (let ((vertico-sort-function nil)) (completing-read "Clone URL: " clone-urls)))
                (clone-dir (file-name-concat my/git-clone-base-dir (file-name-base clone-url)))
                (clone-cmd (format "git clone %s %s" clone-url clone-dir)))
        (shell-command clone-cmd)
        (dired clone-dir)))

;;;; LLMs
(use-package gptel
    :ensure t
    :bind (:map my/leader-map
        ("o l" . (lambda () (interactive) (switch-to-buffer (gptel "*Gemini*"))))
    )
    :config
    ;; Alternative backends/models
    (gptel-make-ollama "Ollama" :host "localhost:11434" :stream t :models '(mistral:latest))

    (defun my/read-gemini-api-key ()
        "Reads a Gemini API key from an encrypted file."
        (with-temp-buffer
            (let ((inhibit-message t))
                (epa-file-insert-file-contents "~/.local/share/gptel/.gemini.gpg"))
            (buffer-string)))

    (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "*Prompt*: ")
    (setf (alist-get 'org-mode gptel-response-prefix-alist) "*Response*: ")

    ;; Defaults
    (setq gptel-default-mode 'org-mode)
    (setq gptel-model 'gemini-3.5-flash)
    (setq gptel-backend (gptel-make-gemini "Gemini" :key (my/read-gemini-api-key) :stream t)))

;;;; Docker
(use-package docker
    :ensure t
    :bind (:map my/leader-map
        ("o d" . docker)
    ))

;;; Email
(use-package notmuch
    :ensure t
    :config
    (defun my/notmuch-hello-insert-buttons (searches)
        "Like 'notmuch-hello-insert-buttons' but includes count of messages with the 'unread' tag"
        (let* ((widest (notmuch-hello-longest-label searches))
	              (tags-and-width (notmuch-hello-tags-per-line widest))
	              (tags-per-line (car tags-and-width))
	              (column-width (cdr tags-and-width))
	              (column-indent 0)
	              (count 0)
	              (reordered-list (notmuch-hello-reflect searches tags-per-line))
	              ;; Hack the display of the buttons used.
	              (widget-push-button-prefix "")
	              (widget-push-button-suffix ""))
            ;; dme: It feels as though there should be a better way to
            ;; implement this loop than using an incrementing counter.
            (mapc (lambda (elem)
	                  ;; (not elem) indicates an empty slot in the matrix.
	                  (when elem
	                      (when (> column-indent 0)
		                      (widget-insert (make-string column-indent ? )))
	                      (let* ((name (plist-get elem :name))
		                            (query (plist-get elem :query))
		                            (oldest-first (cl-case (plist-get elem :sort-order)
				                                      (newest-first nil)
				                                      (oldest-first t)
				                                      (otherwise notmuch-search-oldest-first)))
		                            (exclude (cl-case (plist-get elem :excluded)
				                                 (hide t)
				                                 (show nil)
				                                 (otherwise notmuch-search-hide-excluded)))
		                            (search-type (plist-get elem :search-type))
		                            (msg-count (plist-get elem :count))
                                    (unread-msg-count (plist-get elem :unread)))
		                      (widget-insert (format "%8s"
				                                 (notmuch-hello-nice-number msg-count)))
		                      (widget-insert (format (propertize "(%2d) " 'face 'bold)
                                                 unread-msg-count))
		                      (widget-create 'push-button
			                      :notify #'notmuch-hello-widget-search
			                      :notmuch-search-terms query
			                      :notmuch-search-oldest-first oldest-first
			                      :notmuch-search-type search-type
			                      :notmuch-search-hide-excluded exclude
			                      name)
		                      (setq column-indent
		                          (1+ (max 0 (- column-width (length name)))))))
	                  (cl-incf count)
	                  (when (eq (% count tags-per-line) 0)
	                      (setq column-indent 0)
	                      (widget-insert "\n")))
	            reordered-list)
            ;; If the last line was not full (and hence did not include a
            ;; carriage return), insert one now.
            (unless (eq (% count tags-per-line) 0)
                (widget-insert "\n"))))

    (defun my/notmuch-hello-query-counts (query-list &rest options)
        "Like 'notmuch-hello-query-counts' but includes ':unread' with the unread count"
        (let ((initial-list (with-temp-buffer
                                (dolist (elem query-list nil)
                                    (let ((count-query (or (notmuch-saved-search-get elem :count-query)
                                                           (notmuch-saved-search-get elem :query))))
                                        (insert
                                            (replace-regexp-in-string
                                                "\n" " "
                                                (notmuch-hello-filtered-query count-query
                                                    (or (plist-get options :filter-count)
                                                        (plist-get options :filter))))
                                            "\n")))
                                (unless (= (notmuch--call-process-region (point-min) (point-max) notmuch-command
                                               t t nil "count"
                                               (if (plist-get options :disable-excludes)
                                                   "--exclude=false"
                                                   "--exclude=true")
                                               "--batch") 0)
                                    (notmuch-logged-error
                                        "notmuch count --batch failed"
                                        "Please check that the notmuch CLI is new enough to support `count
--batch'. In general we recommend running matching versions of
the CLI and emacs interface."))
                                (goto-char (point-min))
                                (cl-mapcan
                                    (lambda (elem)
                                        (let* ((elem-plist (notmuch-hello-saved-search-to-plist elem))
                                                  (search-query (plist-get elem-plist :query))
                                                  (filtered-query (notmuch-hello-filtered-query
                                                                      search-query (plist-get options :filter)))
                                                  (message-count (prog1 (read (current-buffer))
                                                                     (forward-line 1))))
                                            (when (and filtered-query (or (plist-get options :show-empty-searches)
                                                                          (> message-count 0)))
                                                (setq elem-plist (plist-put elem-plist :query filtered-query))
                                                (list (plist-put elem-plist :count message-count)))))
                                    query-list))))
            (with-temp-buffer
                (dolist (elem initial-list nil)
                    (let ((count-query (or (notmuch-saved-search-get elem :count-query)
                                           (notmuch-saved-search-get elem :query))))
                        (insert
                            (replace-regexp-in-string
                                "\n" " "
                                (notmuch-hello-filtered-query count-query
                                    (or (plist-get options :filter-count)
                                        (plist-get options :filter))))
                            " and tag:unread" ; Combine the query with the unread tag
                            "\n")))
                (unless (= (notmuch--call-process-region (point-min) (point-max) notmuch-command
                               t t nil "count"
                               (if (plist-get options :disable-excludes)
                                   "--exclude=false"
                                   "--exclude=true")
                               "--batch") 0)
                    (notmuch-logged-error
                        "notmuch count --batch failed"
                        "Please check that the notmuch CLI is new enough to support `count
--batch'. In general we recommend running matching versions of
the CLI and emacs interface."))
                (goto-char (point-min))
                (cl-mapcan
                    (lambda (elem)
                        (let* ((elem-plist (notmuch-hello-saved-search-to-plist elem))
                                  (search-query (plist-get elem-plist :query))
                                  (filtered-query (notmuch-hello-filtered-query
                                                      search-query (plist-get options :filter)))
                                  (message-count (prog1 (read (current-buffer))
                                                     (forward-line 1))))
                            (when (and filtered-query (or (plist-get options :show-empty-searches)
                                                          (> message-count 0)))
                                (list (plist-put elem-plist :unread message-count)))))
                    initial-list))))

    (defun my/notmuch-hello-insert-saved-searches ()
        "Like 'notmuch-hello-insert-saved-searches' but with custom formatting."
        (let ((searches (my/notmuch-hello-query-counts
                            (if notmuch-saved-search-sort-function
                                (funcall notmuch-saved-search-sort-function notmuch-saved-searches)
                                notmuch-saved-searches)
                            :show-empty-searches notmuch-show-empty-saved-searches)))
            (when searches
                (widget-insert "Saved email searches:")
                (widget-insert "\n\n")
                (my/notmuch-hello-insert-buttons searches))))

    (advice-add 'evil-collection-notmuch-show-toggle-delete :override (lambda () (interactive) (evil-collection-notmuch-toggle-tag "del" "show")))
    (advice-add 'evil-collection-notmuch-tree-toggle-delete :override (lambda () (interactive) (evil-collection-notmuch-toggle-tag "del" "tree")))
    (advice-add 'evil-collection-notmuch-search-toggle-delete :override (lambda () (interactive) (evil-collection-notmuch-toggle-tag "del" "search" 'notmuch-search-next-thread)))
    :hook
    (notmuch-show . (lambda () (setq-local header-line-format nil)))
    ;; notmuch-message-mode does not play nice with corfu
    (notmuch-message-mode . (lambda () (corfu-mode -1)))
    :custom
    (notmuch-search-oldest-first nil)
    (notmuch-show-empty-saved-searches t)
    (notmuch-always-prompt-for-sender t)
    (notmuch-column-control 1.0)
    ;; See example: https://github.com/friemen/emacsd/blob/2d5bfda006594a450c7c12cbe301091eb31ebaef/config/my-notmuch.el#L57
    (notmuch-fcc-dirs `((,my/email-gmail-professional . nil)
                        (,my/email-university . nil)))
    (notmuch-saved-searches `((:name "󰇮 Inbox (all)" :query "tag:inbox" :key "i")
                              (:name "󰒊 Sent" :query "tag:sent" :key "s")
                              (:name " Drafts" :query "tag:draft" :key "d")
                              (:name " Gmail" :query ,(format "to:%s and tag:inbox" my/email-gmail) :key "g")
                              (:name "󰃖 Gmail Professional" :query ,(format "to:%s and tag:inbox" my/email-gmail-professional) :key "p")
                              (:name " Wirtualna Polska" :query ,(format "to:%s and tag:inbox" my/email-wp) :key "W")
                              (:name "󰑴 University" :query ,(format "to:%s and tag:inbox" my/email-university) :key "u")
                              (:name "󰛳 Work" :query ,(format "to:%s and tag:inbox" my/email-work) :key "w")
                              (:name "󰴺 SGO" :query "sgo" :key "S")))
    (notmuch-hello-sections '(my/notmuch-hello-insert-saved-searches))
    :bind (:map my/leader-map
        ("o E" . (lambda () (interactive)
                     (notmuch)
                     (widget-forward 1)
                     (forward-char 2)))
    ))

(use-package message
    :defer t
    :custom
    (message-signature "Pozdrawiam.\nMikołaj Trzciński")
    (message-send-mail-function 'message-send-mail-with-sendmail)
    (message-sendmail-envelope-from 'header)
    (message-kill-buffer-on-exit t))

(use-package sendmail
    :defer t
    :custom
    (sendmail-program (executable-find "msmtp")))

(use-package shr
    :defer t
    :custom
    (shr-use-colors nil)
    (shr-use-fonts nil))
