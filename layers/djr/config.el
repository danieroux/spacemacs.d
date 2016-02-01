;; Save on tab-out
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; For the chrome layer
(add-hook 'edit-server-done-hook (lambda () (shell-command "open -a \"Google Chrome\"")))
