;;; $DOOMDIR/personal/config.el -*- lexical-binding: t; -*-

;; Configure LiteLLM backend
(after! gptel
  (gptel-make-anthropic "Claude Sonnet"
    :key 'gptel-api-key
    :stream t))
