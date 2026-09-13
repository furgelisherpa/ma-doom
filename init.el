(doom! :completion
       (company +auto +childframe)
       (ivy +fuzzy)

       :ui
       deft
       doom
       modeline
       doom-quit
       ophints
       hl-todo
       nav-flash
       (popup +all +defaults)
       vc-gutter
       window-select

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets
       (format +onsave)
       multiple-cursors
       rotate-text
       word-wrap

       :emacs
       (dired +icons)
       electric
       undo
       vc

       :term
       eshell
       vterm

       :checkers
       (syntax +flymake)

       :lang
       emacs-lisp
       (nix +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (json +lsp +tree-sitter)
       (yaml +lsp +tree-sitter)
       (web +lsp +tree-sitter)
       (markdown +grip)
       (org +attach +babel +capture +export +noter +present +pretty) 
       (sh +zsh +bash +tree-sitter)
       rest
       rst
       data

       :tools
       (lsp +eglot)
       (lookup +devdocs +docsets)
       projectile
       (magit +forge)
       biblio
       (debugger +dape)
       direnv
       docker
       editorconfig
       (eval +overlay)
       pdf
       gist
       tree-sitter

       :app
       everywhere
       (rss +org)

       :config
       literate
       (default +bindings +smartparens +snippets +evil-commands))
