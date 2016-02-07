(use-package shell)
(djr/sync-mail-and-update-mu4e)

(setq powerline-default-separator nil
      spaceline-pre-hook 'nil ; Does diminish work, only
      )

(setq ns-use-srgb-colorspace nil)

(spaceline-toggle-minor-modes-off)
(spaceline-toggle-line-column-off)
(spaceline-toggle-buffer-size-off)
(spaceline-toggle-buffer-encoding-abbrev-off)

(provide 'djr-config)
