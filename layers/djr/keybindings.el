(bind-key* "M-z" 'spacemacs/toggle-maximize-buffer)

(bind-key* "C-x |" 'split-window-horizontally)
(bind-key* "C-x -" 'split-window-vertically)

(bind-key* "M-j" (lambda () (interactive) (ignore-errors (windmove-down))))
(bind-key* "M-k" (lambda () (interactive) (ignore-errors (windmove-up))))
(bind-key* "M-h" (lambda () (interactive) (ignore-errors (windmove-left))))
(bind-key* "M-l" (lambda () (interactive) (ignore-errors (windmove-right))))

(bind-key* "M-J" (lambda () (interactive) (djr/window-swap-with 'down)))
(bind-key* "M-K" (lambda () (interactive) (djr/window-swap-with 'up)))
(bind-key* "M-H" (lambda () (interactive) (djr/window-swap-with 'left)))
(bind-key* "M-L" (lambda () (interactive) (djr/window-swap-with 'right)))

(bind-key* "M->" (lambda ()
                   (interactive)
                   (enlarge-window 1)
                   (enlarge-window 1 t)))

(bind-key* "M-<" (lambda ()
                   (interactive)
                   (enlarge-window -1)
                   (enlarge-window -1 t)))

(bind-key* "M-SPC" 'helm-mini)
