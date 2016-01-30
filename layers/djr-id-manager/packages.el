(defconst djr-id-manager-packages
  '(id-manager))

(defun djr-id-manager/init-id-manager()
  (use-package id-manager
    :commands id-manager
    :init
    (progn
      (setq idm-database-file "~/Dropbox/Documents/passwords.gpg")
      (bind-key* "C-c i" 'id-manager))))
