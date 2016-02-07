(use-package shell)
(djr/sync-mail-and-update-mu4e)

(setq powerline-default-separator nil
      spaceline-pre-hook 'nil ; Does diminish work, only
      )

(setq ns-use-srgb-colorspace nil)

(make-face 'mode-line-directory-face)
(set-face-attribute 'mode-line-directory-face nil
                    :inherit 'mode-line-face)
(make-face 'mode-line-filename-face)
(set-face-attribute 'mode-line-filename-face nil
                    :inherit 'mode-line-face
                    :foreground "#eab700"
                    :weight 'bold)

(spaceline-define-segment djr-buffer-name
  "My custom way of presenting files"
  (cond
   ((buffer-file-name)
    (format "%s%s"
     (propertize (abbreviate-file-name (file-name-directory (buffer-file-name)))
                 'face 'mode-line-directory-face)
     (propertize (file-name-nondirectory (buffer-file-name)) 'face 'mode-line-filename-face)))
   (t
    (propertize "%b" 'face 'mode-line-filename-face)))
  )

(setq djr-spaceline-left
      '(((evil-state) :separator "|" :face highlight-face)
        anzu auto-compile
        (buffer-modified djr-buffer-name remote-host)
        major-mode
        ((flycheck-error flycheck-warning flycheck-info)
         :when active)
        (version-control :when active)
        (org-pomodoro :when active)
        (org-clock :when active)))

(spaceline-install djr-spaceline-left spaceline-right)

(provide 'djr-config)
