;; Disable title frame
(add-to-list 'default-frame-alist '(undecorated . t))

;; User information
(setq user-full-name "Furgeli Sherpa"
      user-mail-address "furgelizsherpa@gmail.com")

;; Default theme
(setq doom-theme 'ef-bio)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)

;; Default fonts
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15))

;; Enable doom modeline icons
(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-lsp-icon t
      doom-modeline-major-mode-color-icon t)

;; Removes evil modes indicator
(setq doom-modeline-modal nil)

;; Set trash directory
(setq trash-directory "~/.local/share/trash")
(setq delete-by-moving-to-trash t)

;; Per;; Version control optimization
(setq vc-handled-backends '(Git))

;; set specific browser to open links
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

;; Speed of which-key popup
(setq which-key-idle-delay 0.2)

;; Org-mode
;; TODO: make org mode preety
(setq org-directory "~/org/")

;; Web mode
(after! web-mode
  (add-to-list 'auto-mode-alist '("\\.njk\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2))

;; Indentation
(setq-default typescript-ts-mode-indent-offset 2
              js-indent-level 2
              json-reformat:indent-width 2
              css-indent-offset 2)

;; Evil mode
(after! evil
  (setq evil-default-cursor 'box
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'box
        evil-visual-state-cursor 'box
        evil-replace-state-cursor 'box
        evil-operator-state-cursor 'box
        evil-motion-state-cursor 'box
        evil-emacs-state-cursor 'box)

  (map! :leader
        :desc "Quit without saving"
        "Q" #'kill-current-buffer)
  (map! :leader
        :desc "Open Doom cheatsheet"
        "o c" (cmd! (find-file "~/org/doom-cheatsheet.org"))))

;; Search path as `~/.github`, `~/code`
(after! projectile
  (setq projectile-project-search-path '("~/.github/" "~/code/"))
  (defun ma/projectile-cleanup-known-projects ()
    (setq projectile-known-projects
          (seq-filter #'file-directory-p
                      projectile-known-projects))
    (projectile-save-known-projects)
    (projectile-discover-projects-in-search-path))

  (add-hook 'emacs-startup-hook
            #'ma/projectile-cleanup-known-projects))

;; Company box
(after! company-box
  (setq company-box-doc-frame-parameters
        '((internal-border-width . 0))))

;; Custom dashboard
(use-package! dashboard
  :init
  (setq doom-fallback-buffer-name "*dashboard*")
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice
        (lambda () (get-buffer "*dashboard*")))
  (add-hook 'server-after-make-frame-hook
            (lambda ()
              (switch-to-buffer dashboard-buffer-name)
              (dashboard-mode)
              (dashboard-insert-startupify-lists)
              (dashboard-refresh-buffer)))
  (add-hook 'dashboard-mode-hook #'hl-line-mode)

  (setq dashboard-startup-banner (expand-file-name "emacs.png" doom-user-dir))
  (setq dashboard-image-banner-max-height 200)
  (setq dashboard-image-banner-max-width 200)

  (setq dashboard-banner-logo-title "Welcome to Emacs!")
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 4)
                          (agenda   . 4)))
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-footer t)
  (setq dashboard-footer-messages '("Happy hacking with Emacs!")))

;; Markdown
(use-package! impatient-mode
  :commands impatient-mode)

;; Dape
(use-package! dape
  :after nix
  :config
  (setq dape-buffer-window-arrangment 'right)

  (add-to-list 'dape-configs
               `(node-attach
                 modes (js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 command "node"
                 command-args ("-e" "console.log('using existing --inspect process')")
                 port 9229
                 :type "pwa-node"
                 :request "attach"
                 :cwd (lambda () (projectile-project-root))
                 :sourceMaps t
                 :skipFiles ["<node_internals>/**" "**/node_modules/**"]))

  (add-to-list 'dape-configs
               `(nextjs-dev
                 modes (js-mode js-ts-mode typescript-mode typescript-ts-mode tsx-ts-mode)
                 command "pnpm"
                 command-args ("run" "dev")
                 port 9229
                 :type "pwa-node"
                 :request "launch"
                 :cwd (lambda () (projectile-project-root))
                 :runtimeArgs ["--inspect"]
                 :sourceMaps t
                 :skipFiles ["<node_internals>/**" "**/node_modules/**"])))
