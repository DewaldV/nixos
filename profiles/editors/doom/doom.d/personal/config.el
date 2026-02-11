;;; $DOOMDIR/personal/config.el -*- lexical-binding: t; -*-

;; Configure LiteLLM backend
(with-eval-after-load 'gptel
  (gptel-make-anthropic "Claude Sonnet"
    :key 'gptel-api-key
    :stream t))
