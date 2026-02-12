(with-eval-after-load 'org

  ;; Enable org-tempo (<s TAB etc)
  (require 'org-tempo)

  ;; Enable useful structure templates
  (add-to-list 'org-structure-template-alist
               '("sh" . "src bash"))
  (add-to-list 'org-structure-template-alist
               '("py" . "src python"))
  (add-to-list 'org-structure-template-alist
               '("js" . "src js"))
  (add-to-list 'org-structure-template-alist
               '("el" . "src emacs-lisp"))

   ;; Better source block appearance
   (setq org-src-fontify-natively t)
   (setq org-src-tab-acts-natively t)
   (setq org-edit-src-content-indentation 0)
   (setq org-hide-emphasis-markers t)

   ;; Make TAB behave properly inside blocks
   (setq org-src-preserve-indentation t))


(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (js . t))))
