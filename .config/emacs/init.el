;; -*- eval: (outline-minor-mode); -*-

;;; Performance
(setq gc-cons-threshold #x40000000)
(setq read-process-output-max (* 1024 1024 4))
(setenv "LSP_USE_PLISTS" "true")

;;; Customize file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;; Package manager
(use-package package
    :ensure nil
    :init
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(use-package use-package
    :ensure nil
    :custom
    ;; use-package lazy loading stats: 'use-package-report'
    (use-package-compute-statistics t))

;;; General Emacs settings
(setq inhibit-startup-echo-area-message "trzcin")

(use-package f :ensure nil)

(use-package emacs
    :ensure nil
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
    (column-number-mode t)
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
                            (setq-local show-trailing-whitespace t)))
    (text-mode . (lambda () (visual-line-mode)
                            (setq-local show-trailing-whitespace t)))
    (astro-ts-mode . display-line-numbers-mode)
    (typst-ts-mode . display-line-numbers-mode)
    (html-ts-mode . display-line-numbers-mode)
    (yaml-ts-mode . display-line-numbers-mode)

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
    :ensure nil
    :custom
    (search-whitespace-regexp ".*?")
    (isearch-lax-whitespace t)
    (isearch-regexp-lax-whitespace nil)
    (isearch-lazy-count t)
    (lazy-count-prefix-format "(%s/%s) ")
    (lazy-count-suffix-format nil))

;; which-key - show possible keybinds
(use-package which-key
    :ensure nil
    :hook
    (after-init . which-key-mode))

;;; Buffer display
(add-to-list 'display-buffer-alist
    '((or . ((derived-mode . occur-mode)
             (derived-mode . grep-mode)
             (derived-mode . Buffer-menu-mode)
             (derived-mode . log-view-mode)
             (derived-mode . help-mode)))
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (body-function . select-window)))

(add-to-list 'display-buffer-alist
    '("\\`\\*\\(Org \\(Select\\|Note\\)\\|Agenda Commands\\)\\*\\'"
         (display-buffer-in-side-window)
         (dedicated . t)
         (side . bottom)
         (slot . 0)
         (window-parameters . ((mode-line-format . none)))))

(add-to-list 'display-buffer-alist
    '((derived-mode . calendar-mode)
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (mode . (calendar-mode bookmark-edit-annotation-mode ert-results-mode))
         (inhibit-switch-frame . t)
         (dedicated . t)
         (window-height . fit-window-to-buffer)))

(add-to-list 'display-buffer-alist
    '((derived-mode . reb-mode)
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         (inhibit-switch-frame . t)
         (window-height . 4)
         (dedicated . t)
         (preserve-size . (t . t))))

(add-to-list 'display-buffer-alist
    '((derived-mode . trashed-mode)
         (display-buffer-same-window)
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
    (ef-themes-mixed-fonts t)
    (ef-themes-headings '((1 . (2.0))
                          (2 . (1.7))
                          (3 . (1.4))
                          (4 . (1.1))))
    (ef-themes-load-theme 'ef-bio))

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
                       ;; (error-counter (s-join "" '(error-sign flymake-mode-line-error-counter)))
                       (warn-sign (cl-first (alist-get 'warning flymake-margin-indicators-string)))
                       ;; (warn-counter (s-join "" '(warn-sign flymake-mode-line-warning-counter)))
                       (note-sign (cl-first (alist-get 'note flymake-margin-indicators-string))))
                       ;; (note-counter (s-join "" '(note-sign flymake-mode-line-note-counter))))
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
    :ensure nil
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
        (when-let* ((output-file (read-string "Output PDF: ")))
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

    :bind (:map my/leader-map
        ("c t" . consult-theme)
        ("c i" . consult-info)
        ("c o" . consult-outline)
        ("c g" . consult-ripgrep)
        ("c f" . consult-find)
        ("c s" . consult-imenu)
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
(use-package corfu
    :ensure t
    :defer t
    :custom
    (corfu-auto t)
    (corfu-auto-delay 0)
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
        ("$" . evil-end-of-visual-line)
        ("0" . evil-beginning-of-visual-line)

        ("U" . evil-redo)

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

        ;; Commands
        ("&" . async-shell-command)
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

;; Vim-like numbers workflow
;; Fix missing incf function: 'https://github.com/juliapath/evil-numbers/issues/30'
(require 'cl-lib)
(defalias 'incf 'cl-incf)
(with-eval-after-load 'comp
    (add-to-list 'native-comp-jit-compilation-deny-list "evil-numbers"))

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
    :bind (:map evil-normal-state-map
        ("z=" . jinx-correct)
        ("]s" . jinx-next)
        ("[s" . jinx-previous)
    ))

(use-package epa
    :ensure nil
    :defer t
    :custom
    (epg-pinentry-mode 'loopback)
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
    :ensure nil
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

(use-package org-tempo
    :ensure nil
    :after org)

(use-package ob-python :after org)
(use-package ob-lua :after org)
(use-package ob-gnuplot :after org)

(defvar my/journal-dir
    "~/Documents/org-notes/Journal"
    "The directory in which journal entries will be stored.")

(defun my/journal-create-or-edit-todays-entry ()
    "Switches to todays journal file if it exists or creates one if needed."
    (interactive)
    (let*
        ((journal-file (f-join my/journal-dir (format-time-string "%Y-%m-%d-dziennik.org.gpg"))))
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
    :ensure t
    :after pdf-tools)

;;; EPUBs
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

;;; Utilities
(use-package calendar
    :ensure nil
    :defer t
    :custom
    (calendar-week-start-day 1)
    :bind (:map my/leader-map
        ("o c" . calendar)
    ))

(use-package calc
    :ensure nil
    :defer t
    :bind (:map my/leader-map
        ("o C" . calc)
    ))

(use-package man
    :ensure nil
    :defer t
    :custom
    (Man-support-remote-systems t))

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

;;;; Treesitter
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
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-ts-mode)) ; CUDA C

;;;; LSP
(use-package lsp-mode
    :ensure t

    :hook
    (lsp-mode . lsp-enable-which-key-integration)
    ((
        ;; Configs
        json-ts-mode
        yaml-ts-mode

        ;; Web
        html-ts-mode
        css-ts-mode
        js-ts-mode
        typescript-ts-mode
        tsx-ts-mode
        svelte-ts-mode
        astro-ts-mode
        vue-ts-mode

        ;; Other languages
        python-ts-mode
        go-ts-mode
        rust-ts-mode
        typst-ts-mode
        c-ts-mode
    ) . lsp-deferred)

    :commands lsp

    :custom
    (lsp-inlay-hint-enable nil)
    (lsp-completion-provider :none)
    (lsp-session-file (locate-user-emacs-file ".lsp-session"))
    (lsp-log-io nil)
    (lsp-idle-delay 0.5)
    (lsp-keep-workspace-alive nil)

    ;; Core settings
    (lsp-enable-xref t)
    (lsp-auto-configure t)
    (lsp-enable-links nil)
    (lsp-eldoc-enable-hover t)
    (lsp-eldoc-render-all t)
    (lsp-enable-file-watchers nil)
    (lsp-enable-folding nil)
    (lsp-enable-imenu t)
    (lsp-enable-indentation nil)
    (lsp-enable-on-type-formatting nil)
    (lsp-enable-suggest-server-download t)
    (lsp-enable-symbol-highlighting nil)
    (lsp-enable-text-document-color t)
    (lsp-auto-register-remote-clients nil)

    ;; Completion settings
    (lsp-completion-enable t)
    (lsp-completion-enable-additional-text-edit t)
    (lsp-enable-snippet t)
    (lsp-completion-show-kind t)

    ;; Lens settings
    (lsp-lens-enable nil)

    ;; Headerline settings
    (lsp-headerline-breadcrumb-enable nil)

    ;; Semantic settings
    (lsp-semantic-tokens-enable nil)

    :init
    ;; Ensure installed language servers
    (lsp-ensure-server 'eslint)
    (lsp-ensure-server 'svelte-ls)
    (lsp-ensure-server 'vue-semantic-server)

    ;; Astro
    ;; 'sudo npm i -g @astrojs/language-server'
    ;; 'sudo npm i -g prettier prettier-plugin-astro'

    ;; Add emmet support
    ;; 'npm i -g @olrtg/emmet-language-server'
    (lsp-register-client (make-lsp-client
                          :new-connection (lsp-stdio-connection '("emmet-language-server" "--stdio"))
                          :priority -1
                          :add-on? t
                          :multi-root t
                          :activation-fn (lsp-activate-on "html" "javascriptreact" "typescriptreact" "astro" "svelte" "vue" "css" "scss")
                          :server-id 'emmet))

    :config
    (keymap-set my/leader-map "l" lsp-command-map))

(use-package eldoc-box ; Documentation in child frame
    :ensure t
    :after evil
    :init
    (global-eldoc-mode -1)
    :custom
    (eldoc-echo-area-use-multiline-p nil)
    :bind (:map evil-normal-state-map
        ("K" . (lambda () (interactive) (eldoc)
                                        (eldoc-box-help-at-point)))
    ))

(use-package yasnippet
    :ensure t
    :init
    (yas-global-mode))

(use-package flymake
    :ensure nil
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
    :ensure nil
    :defer t
    :custom
    (diff-font-lock-syntax nil)) ; Disable code syntax highlighting in diffs

(use-package ediff
    :ensure nil
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
    :config
    (global-diff-hl-mode)
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
                (clone-dir (f-join my/git-clone-base-dir (file-name-base clone-url)))
                (clone-cmd (format "git clone %s %s" clone-url clone-dir)))
        (shell-command clone-cmd)
        (dired clone-dir)))

;;;; LLMs
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

;;;; Docker
(use-package docker
    :ensure t
    :custom
    (docker-compose-command "docker compose")
    :bind (:map my/leader-map
        ("o d" . docker)
    ))

;;; Music
(use-package ready-player
    :ensure t
    :defer t
    :hook
    (ready-player-major-mode . (lambda ()
                                   (setq olivetti-body-width 0)
                                   (olivetti-mode)
                                   (visual-line-mode)))
    :config
    (ready-player-mode)
    (evil-define-key 'normal ready-player-major-mode-map (kbd "m") 'ready-player-menu))

;;; Email
(use-package notmuch
    :ensure t
    :custom
    (notmuch-search-oldest-first nil)
    :bind (:map my/leader-map
        ("o E" . notmuch)
    ))

(use-package shr
    :ensure nil
    :defer t
    :custom
    (shr-use-colors nil)
    (shr-use-fonts nil))

;;; Typst
(use-package typst-preview
    :ensure t
    :defer t
    :custom
    (typst-preview-invert-colors "never"))

(use-package websocket
    :ensure t
    :defer t)
