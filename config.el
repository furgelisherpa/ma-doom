;; disable title frame
(add-to-list 'default-frame-alist '(undecorated . t))

;; user information
(setq user-full-name "Furgeli Sherpa"
      user-mail-address "furgelizsherpa@gmail.com")

;; default theme
(setq doom-theme 'ef-bio)

;; relative line numbers, easier motion counts
(setq display-line-numbers-type 'relative)

;; default fonts (nerd font for icons)
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 16))

;; enable doom modeline icons
(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-lsp-icon t
      doom-modeline-major-mode-color-icon t)

;; hide evil state indicator, saves space
(setq doom-modeline-modal nil)

;; move deleted files to trash, not gone forever
(setq trash-directory "~/.local/share/trash")
(setq delete-by-moving-to-trash t)

;; dump `~', `#` files into ~/.local/share/emacs, keeps projects clean
(make-directory "~/.local/share/emacs/backup/" t)
(make-directory "~/.local/share/emacs/autosave/" t)

(setq backup-directory-alist
      '(("." . "~/.local/share/emacs/backup/"))
      backup-by-copying t
      auto-save-file-name-transforms
      '((".*" "~/.local/share/emacs/autosave/" t)))

;; per version control optimization, only check Git
(setq vc-handled-backends '(Git))

;; open links in qutebrowser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

;; faster which-key popup
(setq which-key-idle-delay 0.2)

;; :editor evil
(after! evil
  ;; same box cursor in all states
  (setq evil-default-cursor 'box
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'box
        evil-visual-state-cursor 'box
        evil-replace-state-cursor 'box
        evil-operator-state-cursor 'box
        evil-motion-state-cursor 'box
        evil-emacs-state-cursor 'box)

  ;; always split below and right
  (setq evil-split-window-below t
        evil-vsplit-window-right t)

  ;; auto substitute globally, no /g needed
  (setq evil-ex-substitute-global t)

  ;; SPC Q closes buffer quickly
  (map! :leader
        :desc "Quit without saving"
        "Q" #'kill-current-buffer))

;; Search path as `~/.github`, `~/code`, auto-discover projects
(after! projectile
  (setq projectile-project-search-path '("~/.github/" "~/code/" "~/project/"))

  ;; drop dead project entries
  (defun ma/projectile-cleanup-known-projects ()
    (setq projectile-known-projects
          (seq-filter #'file-directory-p
                      projectile-known-projects))
    (projectile-save-known-projects)
    (projectile-discover-projects-in-search-path))

  (add-hook 'emacs-startup-hook
            #'ma/projectile-cleanup-known-projects))

;; :editor evil search, recenter after jumping to match
(advice-add #'evil-ex-search-next :after #'doom-recenter-a)
(advice-add #'evil-ex-search-previous :after #'doom-recenter-a)

;; :completion corfu, near-instant popup after 2 chars
(after! corfu
  (setq corfu-auto-delay 0.05
        corfu-auto-prefix 2))

;; doc popup beside candidates
(after! corfu-popupinfo
  (setq corfu-popupinfo-delay '(0.2 . 0.1)))

;; :tools lsp
(after! lsp-mode
  (setq lsp-auto-guess-root t
        lsp-headerline-breadcrumb-enable t
        lsp-enable-text-document-color t
        lsp-eldoc-enable-hover nil              ; less echo-area noise
        lsp-enable-indentation nil              ; prettier handles it
        lsp-modeline-diagnostics-enable nil
        lsp-modeline-code-actions-enable nil
        lsp-clients-typescript-prefer-use-project-ts-server t
        lsp-file-watch-threshold 5000
        lsp-inlay-hint-enable t)

  ;; ignore heavy dirs, keeps file watcher fast
  (dolist (dir '("[/\\\\]\\.next\\'"
                 "[/\\\\]\\.vercel\\'"
                 "[/\\\\]\\.direnv\\'"
                 "[/\\\\]coverage\\'"
                 "[/\\\\]node_modules\\'"
                 "[/\\\\]dist\\'"
                 "[/\\\\]\\.git\\'"
                 "[/\\\\]\\.cache\\'"
                 "[/\\\\]build\\'"))
    (add-to-list 'lsp-file-watch-ignored-directories dir))

  ;; not using GraphQL
  (add-to-list 'lsp-disabled-clients 'graphql-lsp))

;; disable lsp-ui popups, too distracting
(after! lsp-ui
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse nil
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics nil))

;; trigger completion on "."
(setq-hook! 'lsp-completion-mode-hook corfu-auto-trigger ".")

;; indentation, 2 spaces to match prettier
(setq-default typescript-ts-mode-indent-offset 2
              js-indent-level 2
              json-reformat:indent-width 2
              css-indent-offset 2)

;; :lang web
(after! web-mode
  ;; nunjucks templates as web-mode
  (add-to-list 'auto-mode-alist '("\\.njk\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2))

;; tailwind completion, also in ts-modes
(use-package! lsp-tailwindcss
  :after lsp-mode
  :init (setq lsp-tailwindcss-add-on-mode t)
  :config
  (dolist (mode '(html-ts-mode css-ts-mode))
    (add-to-list 'lsp-tailwindcss-major-modes mode)
    (setq lsp-tailwindcss-completion-mode "lsp")))

;; :tools magit
(setq magit-show-long-lines-warning nil
      magit-repository-directories '(("~/.github" . 2))
      magit-save-repository-buffers nil
      magit-inhibit-save-previous-winconf t
      evil-collection-magit-want-horizontal-movement t
      magit-openpgp-default-signing-key "7DFEB511800D7A98152C934A8B8E2EFE97E11A51" ; signed commits
      ;; rebase on pull, autostash to keep local changes safe
      transient-values '((magit-rebase "--autosquash" "--autostash")
                         (magit-pull "--rebase" "--autostash")
                         (magit-revert "--autostash")))

;;; :lang org
;; single org dir for notes, roam, archive, agenda
(setq org-directory "~/org/"
      org-roam-directory org-directory
      org-roam-db-location (file-name-concat org-directory ".org-roam.db")
      org-archive-location (file-name-concat org-directory ".archive/%s::")
      org-agenda-files (list org-directory)
      org-agenda-span 'day
      org-log-done-with-time nil
      org-habit-show-habits-only-for-today nil
      org-modern-table nil)

;; org keys, gj/gk jump headings, SPC n for roam
(map! (:after evil-org
       :map evil-org-mode-map
       :n "gk" (cmds! (org-on-heading-p)
                      #'org-backward-element
                      #'evil-previous-visual-line)
       :n "gj" (cmds! (org-on-heading-p)
                      #'org-forward-element
                      #'evil-next-visual-line))
      :o "o" #'evil-inner-symbol
      :leader
      (:prefix "n"
               "b" #'org-roam-buffer-toggle
               "i" #'org-roam-node-insert
               "r" #'org-roam-node-find
               "R" #'org-roam-capture))

(after! org
  ;; habit tracking
  (add-to-list 'org-modules 'org-habit)

  ;; fold to 2 levels, custom ellipsis, quick capture templates
  (setq org-startup-folded 'show2levels
        org-ellipsis " [...] "
        org-capture-templates
        '(("t" "todo" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\n%i\n%a"
           :prepend t)
          ("d" "deadline" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nDEADLINE: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("s" "schedule" entry (file+headline "todo.org" "Inbox")
           "* [ ] %?\nSCHEDULED: <%(org-read-date)>\n\n%i\n%a"
           :prepend t)
          ("c" "check out later" entry (file+headline "todo.org" "Check out later")
           "* [ ] %?\n%i\n%a"
           :prepend t)))

  ;; lms-api learning log, fixed format
  (add-to-list 'org-capture-templates
               '("p" "lms-api progress entry" plain
                 (file "~/.github/lms-api/docs/PROGRESS.md")
                 "### %<%Y-%m-%d> — Phase %^{Phase|0|1|2|3|4|5|6|7|8|9|10}, %^{Topic}\n\n**One-liner:** %?\n\n**Learned:** \n\n**Shaky:** \n\n**Blocked on:** Nothing\n\n**Next:** \n\n---\n"
                 :empty-lines 1)))

;; agenda, compact view and sane sort order
(after! org-agenda
  (setq org-agenda-todo-list-sublevels nil
        org-agenda-compact-blocks t
        org-agenda-sorting-strategy
        '((agenda time-up category-keep habit-up priority-down)
          (todo priority-down category-keep) (tags priority-down category-keep)
          (search category-keep))))

(after! org-roam
  ;; date-prefixed filenames for extracted notes
  (setq org-roam-extract-new-file-path "%<%Y%m%d>-${slug}.org")
  ;; include roam files tagged for agenda
  (cl-callf nconc org-agenda-files (org-roam-agenda-project-files))

  ;; capture templates, bodies from ~/org/template/
  (setq org-roam-capture-templates
        `(("n" "note" plain
           ,(format "#+title: ${title}\n%%[%s/template/note.org]" org-roam-directory)
           :target (file "notes/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("p" "project" plain
           ,(format "#+title: ${title}\n%%[%s/template/project.org]" org-roam-directory)
           :target (file "project/%<%Y%m%d>-${slug}.org")
           :unnarrowed t)
          ("f" "ref" plain
           ,(format "#+title: ${title}\n%%[%s/template/ref.org]" org-roam-directory)
           :target (file "ref/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("w" "works" plain
           ,(format "#+title: ${title}\n%%[%s/template/works.org]" org-roam-directory)
           :target (file "works/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ("c" "contact" plain
           ,(format "#+title: ${title}\n%%[%s/template/contact.org]" org-roam-directory)
           :target (file "contact/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
          ;; GPG-encrypted private notes
          ("s" "secret" plain "#+title: ${title}\n\n"
           :target (file "secret/%<%Y%m%d%H%M%S>-${slug}.org.gpg")
           :unnarrowed t))))

;; slides, only top-level headings split slides
(after! org-tree-slide
  (setq org-tree-slide-skip-outline-level 2))

;; org-roam UX tweaks
(after! org-roam
  (add-to-list 'org-roam-completion-functions #'org-roam-complete-tag-at-point)
  (add-hook 'org-roam-find-file-hook #'org-roam-update-slug-on-save-h)
  (add-hook 'org-roam-buffer-postrender-functions #'magit-section-show-level-2)
  ;; group backlinks by file
  (advice-add #'org-roam-backlinks-section :override #'org-roam-grouped-backlinks-section)
  (advice-add #'org-roam-node-visit :around #'+popup-save-a)
  (advice-add #'org-roam-node-list :filter-return #'org-roam-restore-insertion-order-for-tags-a)
  (advice-add #'org-roam-buffer-set-header-line-format :after #'org-roam-add-preamble-a))

;; latex previews as crisp SVG
(setq org-preview-latex-process-alist
      '((dvisvgm
         :programs ("pdflatex" "dvisvgm")
         :description "dvi > svg"
         :message "you need to install latex and dvisvgm."
         :image-input-type "dvi"
         :image-output-type "svg"
         :image-size-adjust (1.7 . 1.5)
         :latex-compiler ("pdflatex -interaction nonstopmode -output-format=dvi -output-directory=%o %f")
         :image-converter ("dvisvgm %f --no-fonts --bbox=min --scale=%S --output=%O"))))

;; use the dvisvgm pipeline
(setq org-preview-latex-default-process 'dvisvgm)

;; org-modern stars, filled when open, hollow when folded
(after! org-modern
  (setq org-modern-star 'fold
        org-modern-fold-stars '(("◉" . "○") ("◈" . "◇") ("✸" . "✧"))))

;; !package: dashboard, custom startup screen
(use-package! dashboard
  :init
  (setq doom-fallback-buffer-name "*dashboard*")
  :config
  (dashboard-setup-startup-hook)

  ;; show on startup and new emacsclient frames
  (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
  (add-hook 'server-after-make-frame-hook #'dashboard-open)

  ;; hide cursor and hl-line, it's a menu
  (add-hook 'dashboard-mode-hook
            (lambda ()
              (setq-local global-hl-line-mode nil)
              (hl-line-mode -1)
              (setq-local cursor-type nil)
              (setq-local evil-normal-state-cursor nil)
              (setq-local evil-motion-state-cursor nil)
              (setq-local evil-emacs-state-cursor nil)))

  ;; small banner, no title text
  (setq dashboard-startup-banner (expand-file-name "splash.png" doom-user-dir))
  (setq dashboard-image-banner-max-height 150)
  (setq dashboard-image-banner-max-width 150)
  (setq dashboard-banner-logo-title nil)

  ;; centered, only sections I use
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents   . 5)
                          (projects . 4)
                          (agenda   . 4)))
  (setq dashboard-projects-backend 'projectile)

  ;; nerd-icons to match the rest
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-footer-messages '("Welcome to the church of Emacs!"))

  ;; dim startup-info line
  (defface +dashboard-init-info-face
    '((t (:inherit font-lock-comment-face :height 0.9)))
    "Face for the dashboard startup-info line."
    :group 'dashboard)
  (defun +dashboard-init-info ()
    (propertize (dashboard-init--info) 'face '+dashboard-init-info-face))
  (setq dashboard-init-info #'+dashboard-init-info)

  ;; inherit faces so colors follow the theme
  (custom-set-faces!
    '(dashboard-heading
      :inherit (font-lock-keyword-face bold)
      :height 1.0)
    '(dashboard-items-face
      :inherit default)
    '(dashboard-no-items-face
      :inherit font-lock-comment-face)
    '(dashboard-footer-face
      :inherit font-lock-doc-face
      :slant italic)
    '(dashboard-footer-icon-face
      :inherit dashboard-footer-face)
    '(dashboard-navigator
      :inherit font-lock-keyword-face))

  ;; agenda lines, time only no tags
  (setq dashboard-agenda-prefix-format " %-10s ")
  (setq dashboard-agenda-tags-format 'ignore))

;; !package: apheleia, format on save per language
(after! apheleia
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'alejandra)
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'html-ts-mode apheleia-mode-alist) 'prettier)
  (setf (alist-get 'c-ts-mode apheleia-mode-alist) 'clang-format)
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist) 'clang-format)
  (apheleia-global-mode +1))

;; !package: epub, read books in Emacs
(use-package! nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; !package: doc-view, sharp PDFs, no big-file warning under 50MB
(after! doc-view
  (setq doc-view-resolution 300
        doc-view-mupdf-use-svg (image-type-available-p 'svg)
        large-file-warning-threshold (* 50 (expt 2 20))))

;; !package: ox-odt, open OpenDocument files in doc-view
(add-to-list 'auto-mode-alist '("\\.\\(?:OD[CFIGPST]\\|od[cfigpst]\\)\\'" . doc-view-mode-maybe))

;; !package: agenix, decrypt age secrets with SSH keys
(use-package! agenix
  :mode ("\\.age\\'" . agenix-mode)
  :config
  (add-to-list 'agenix-key-files "~/.config/ssh/id_ed25519")
  (add-to-list 'agenix-key-files "/etc/ssh/host_ed25519")
  (dolist (file (doom-glob "~/.config/ssh/*/id_ed25519"))
    (add-to-list 'agenix-key-files file)))
