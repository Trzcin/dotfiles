;; Performance
(setq gc-cons-threshold #x40000000)
(setq read-process-output-max (* 1024 1024 4))
(setenv "LSP_USE_PLISTS" "true")

;; Maximize on startup
(setq initial-frame-alist '((fullscreen . maximized)))
(setq default-frame-alist '((undecorated . t)))

;; Disable some UI elements
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fringe-mode 0)
