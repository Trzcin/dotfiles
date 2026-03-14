;; Startup welcome screen
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
