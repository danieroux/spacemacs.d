;; Save on tab-out
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))
