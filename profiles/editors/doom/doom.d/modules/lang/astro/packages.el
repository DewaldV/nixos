;; -*- no-byte-compile: t; -*-
;;; lang/astro/packages.el

;; from: https://github.com/edmundmiller/.doom.d/tree/main/modules/lang/astro

(package! treesit-auto)
(package! astro-ts-mode)

(when (modulep! +lsp)
  (package! lsp-tailwindcss
    :recipe (:host github :repo "merrickluo/lsp-tailwindcss")))
