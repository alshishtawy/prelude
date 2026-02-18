(use-package vterm
  :ensure t
  :config
  (setq vterm-always-compile-module t))

;; Override Prelude's default C-c t (crux-visit-term-buffer) with vterm
(with-eval-after-load 'prelude-mode
  (define-key prelude-mode-map (kbd "C-c t") 'vterm))
