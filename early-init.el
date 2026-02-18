;;; early-init.el --- Runs before frame creation and package init

;; Set frame size and font before the first frame appears to avoid
;; the window starting small and then resizing on startup.
(setq default-frame-alist
      '((width  . 140)
        (height . 40)
        (font   . "DejaVu Sans Mono-14")))

;;; early-init.el ends here
