(doom! :completion
       (corfu +orderless +dabbrev +icons)
       vertico

       :ui
       deft
       workspaces
       (doom +tabs)
       modeline
       doom-quit
       ophints
       hl-todo
       (popup +all +defaults)
       (vc-gutter +pretty)
       window-select
       indent-guides

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets
       (format +onsave)
       multiple-cursors
       rotate-text
       word-wrap
       (whitespace +guess +trim)

       :emacs
       (dired +icons +dirvish)
       electric
       tramp
       undo
       vc

       :term
       ghostel

       :checkers
       (syntax +childframe +icons)
       spell

       :lang
       emacs-lisp
       (nix +lsp +tree-sitter)
       (cc +lsp +tree-sitter)
       (gdscript +lsp +tree-sitter)
       (latex +cdlatex +lsp +fold)
       (javascript +lsp +tree-sitter)
       (json +lsp +tree-sitter)
       (lua +lsp +tree-sitter)
       (markdown +tree-sitter +grip)
       (web +lsp +tree-sitter)
       (yaml +lsp +tree-sitter)
       (org +attach +babel +capture +export +noter +present
            +dragndrop +roam2 +pretty +forge +jupyter +gnuplot)
       (python +lsp +tree-sitter +uv +pyright)
       (sh +zsh +bash +lsp)
       rest
       rst
       data

       :tools
       debugger
       editorconfig
       biblio
       pdf
       gist
       tree-sitter
       (lsp +peek)
       (lookup +devdocs +docsets +dictionary)
       projectile
       (magit +forge +childframe)
       (eval +overlay)

       :app
       everywhere
       (rss +org)

       :config
       literate
       (default +bindings +smartparens +snippets +evil-commands +gnupg))
