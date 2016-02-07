(use-package shell)
(djr/sync-mail-and-update-mu4e)

(setq ns-use-srgb-colorspace nil)
(setq powerline-default-separator nil
      spaceline-pre-hook 'nil ; Does diminish work, only
      )

(spaceline-toggle-line-column-off)
(spaceline-toggle-buffer-encoding-abbrev-off)

;; I want it to stand out, slightly. Could not get a useful face from powerline
;; for this
(make-face 'mode-line-filename-face)
(set-face-attribute 'mode-line-filename-face nil
                    :inherit 'mode-line-face
                    :foreground "#eab700"
                    :weight 'bold)

(defface djr-filename-active-face
  '((t (:inherit 'powerline-active1 :foreground "#eab700")))
  "Active filename"
  :group 'powerline)

(spaceline-define-segment djr-buffer-name
  "My custom way of presenting files"
  (let* ((active (powerline-selected-window-active))
         (directory-face (spaceline--get-face 'face1 active))
         (filename-face (if active
                            'djr-filename-active-face
                          directory-face)))
    (cond
     ((buffer-file-name)
      (format "%s%s"
              (propertize (abbreviate-file-name (file-name-directory (buffer-file-name)))
                          'face directory-face)
              (propertize (file-name-nondirectory (buffer-file-name)) 'face filename-face)))
     (t
      (propertize "%b" 'face 'mode-line-filename-face)))))

(setq djr-spaceline-left
      '(((evil-state) :separator "|" :face highlight-face)
        anzu auto-compile
        (buffer-modified remote-host)
        (djr-buffer-name :skip-alternate t)
        major-mode
        ((flycheck-error flycheck-warning flycheck-info)
         :when active)
        (version-control :when active)
        (org-pomodoro :when active)
        (org-clock :when active)))

(spaceline-install djr-spaceline-left spaceline-right)

(provide 'djr-config)
