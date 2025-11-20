;;; lang/templ/config.el -*- lexical-binding: t; -*-

(use-package! templ-ts-mode
  :config
  (let ((templ-recipe (make-treesit-auto-recipe
                       :lang 'templ
                       :ts-mode 'templ-ts-mode
                       :url "https://github.com/vrischmann/tree-sitter-templ"
                       :revision "master"
                       :source-dir "src")))
    (add-to-list 'treesit-auto-recipe-list templ-recipe)))
