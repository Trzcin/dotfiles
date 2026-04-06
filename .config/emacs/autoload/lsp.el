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
    ;; Some issues with 'completionItem/resolve'.
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

;; Documentation in child frame
(use-package eldoc-box
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
