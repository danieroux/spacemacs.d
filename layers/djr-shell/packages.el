(defconst djr-shell-packages
  '())

(defun shell/pre-init-eshell ()
  (spacemacs|use-package-add-hook eshell
    :post-init
    (progn
      (setq eshell-where-to-jump 'begin
            eshell-review-quick-commands 'not-even-short-output
            eshell-glob-case-insensitive t
            eshell-prefer-lisp-functions t
            eshell-smart-space-goes-to-end t))))
