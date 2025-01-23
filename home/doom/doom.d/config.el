;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dewald Viljoen"
      user-mail-address "dv@dewaldv.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/notes/")
(setq projectile-project-search-path '(("~/Projects/" . 2) ("~/Dev/" . 2)))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Turn off Deep indents for ruby-mode
(setq ruby-deep-indent-paren nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; BEGIN astro-ts
;; Source: https://edmundmiller.dev/posts/emacs-astro/

;; set up astro-ts-mode
(use-package! astro-ts-mode
  :after treesit-auto
  :init
  (when (modulep! +lsp)
    (add-hook 'astro-ts-mode-hook #'lsp! 'append))
  :config
  (global-treesit-auto-mode)
  (let ((astro-recipe (make-treesit-auto-recipe
                       :lang 'astro
                       :ts-mode 'astro-ts-mode
                       :url "https://github.com/virchau13/tree-sitter-astro"
                       :revision "master"
                       :source-dir "src")))
    (add-to-list 'treesit-auto-recipe-list astro-recipe)))

;; prettier support for *.astro files
(set-formatter! 'prettier-astro
  '("npx" "prettier" "--parser=astro"
    (apheleia-formatters-indent "--use-tabs" "--tab-width" 'astro-ts-mode-indent-offset))
  :modes '(astro-ts-mode))

;; tailwind-css intellisense
(use-package! lsp-tailwindcss
  :when (modulep! +lsp)
  :init
  (setq! lsp-tailwindcss-add-on-mode t)
  :config
  (add-to-list 'lsp-tailwindcss-major-modes 'astro-ts-mode))

;; END astro-ts
