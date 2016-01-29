(bind-key* "M-z" 'spacemacs/toggle-maximize-buffer)

(bind-key* "C-x |" 'split-window-horizontally)
(bind-key* "C-x -" 'split-window-vertically)

(bind-key* "M-j" (lambda () (interactive) (ignore-errors (windmove-down))))
(bind-key* "M-k" (lambda () (interactive) (ignore-errors (windmove-up))))
(bind-key* "M-h" (lambda () (interactive) (ignore-errors (windmove-left))))
(bind-key* "M-l" (lambda () (interactive) (ignore-errors (windmove-right))))
