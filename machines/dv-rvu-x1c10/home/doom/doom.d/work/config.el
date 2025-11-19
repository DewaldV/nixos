;;; $DOOMDIR/work/config.el -*- lexical-binding: t; -*-

;; Configure LiteLLM backend
(after! gptel
  (gptel-make-openai "RVU LiteLLM"
    :host "litellm.external-ai.rvu.cloud"
    :endpoint "/v1/chat/completions"
    :stream t
    :key gptel-api-key
    :models '("claude-haiku-4-5@20251001" "eu.anthropic.claude-sonnet-4-5-20250929-v1:0")))
