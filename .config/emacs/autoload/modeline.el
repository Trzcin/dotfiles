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
    '(:eval (when (and (mode-line-window-selected-p) (flymake-running-backends))
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

;; Disable VC in TRAMP (performance)
(setq vc-ignore-dir-regexp
    (format "%s\\|%s"
        vc-ignore-dir-regexp
        tramp-file-name-regexp))
