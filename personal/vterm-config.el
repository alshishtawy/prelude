(use-package vterm
  :ensure t
  :bind ("C-c v" . vterm)
  :config
  ;; Automatically compile the module without asking
  (setq vterm-always-compile-module t))

(with-eval-after-load 'vterm
  ;; This hook disables prelude-mode only in vterm buffers
  ;; so that C-a, C-e, etc., are sent to the terminal instead of Emacs.
  (add-hook 'vterm-mode-hook (lambda () (prelude-off))))

;; Overwrite Prelude's default terminal shortcut
(with-eval-after-load 'prelude-mode
  (define-key prelude-mode-map (kbd "C-c t") 'vterm))
