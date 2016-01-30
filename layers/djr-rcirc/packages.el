;;; packages.el --- djr-rcirc layer packages file for Spacemacs.
(defconst djr-rcirc-packages
  '(rcirc))

(defun djr-rcirc/pre-init-rcirc ()
  (setq rcirc-prompt "%n %t> "
        rcirc-id-string "it has come to this."
        rcirc-scroll-show-maximum-output nil
        rcirc-omit-responses '("AWAY" "MODE")
        rcirc-omit-threshold 0
        rcirc-fill-flag nil
        rcirc-log-flag t
        rcirc-trap-errors-flag nil
        rcirc-kill-channel-buffers t)

  (spacemacs|use-package-add-hook rcirc
    :post-config
    (progn

      (bind-key "C-c C-@" 'djr/rcirc-clear-screen-and-next-activity rcirc-track-minor-mode-map)
      (bind-key "C-c C-SPC" 'djr/rcirc-clear-screen-and-next-activity rcirc-track-minor-mode-map)

      (defun djr/rcirc-mode-setup ()
        (interactive)
        (setq rcirc-omit-mode nil)
        (rcirc-omit-mode)
        ;(emojify-mode)
        (flyspell-mode 1)
        (djr/general-to-less-general-slack-channel-name)
        (set (make-local-variable 'scroll-conservatively) 8192))

      (spacemacs/add-to-hook 'rcirc-mode-hook '(djr/rcirc-mode-setup))

      (defadvice rcirc-format-response-string (after dim-entire-line)
        "Dim whole line for senders whose nick matches `rcirc-dim-nicks'."
        (when (and rcirc-dim-nicks sender
                   (string-match (regexp-opt rcirc-dim-nicks 'words) sender))
          (setq ad-return-value (rcirc-facify ad-return-value 'rcirc-dim-nick))))
      (ad-activate 'rcirc-format-response-string)

      (set-face-foreground 'rcirc-dim-nick "grey" nil)

      ;; Override
      (defun rcirc-short-buffer-name (buffer)
        "Override to ignore rcirc-short-buffer-name var - and to always use the real buffer-name"
        (with-current-buffer buffer
          (buffer-name)))

      ;; Swallow KEEPALIVE messages with a sledgehammer.
      (defun rcirc-handler-NOTICE (process sender args text))

      ;; Slack does not set a topic, and breaks this handler. So stop handling topics as a quickfix.
      (defun rcirc-handler-333 (process sender args _text))

      (defun-rcirc-command slack (arg)
        "Open slack in the browser for this IRC integration"
        (let* ((connected-host (process-name process))
               ;; I have my slack servers defined as znc-slackserver
               (slack-name (second (split-string connected-host "-")))
               (slack-server (format "https://%s.slack.com/messages/%s" slack-name target))
               (open-message (format "Opening %s" slack-server)))
          (rcirc-print process nil "SLACK" target open-message)
          (browse-url slack-server)))

      (defun endless/mark-read ()
        "Mark buffer as read up to current line."
        (let ((inhibit-read-only t))
          (put-text-property
           (point-min) (line-beginning-position)
           'face       'font-lock-comment-face)))

      (defun endless/bury-buffer ()
        "Bury buffer and maybe close its window."
        (interactive)
        (endless/mark-read)
        (bury-buffer)
        (when (cdr (window-list nil 'nomini))
          (delete-window)))

      (defun djr/rcirc-clear-screen-and-next-activity ()
        (interactive)
        (when (equal major-mode 'rcirc-mode)
          (djr/rcirc-clear-screen))
        (call-interactively 'rcirc-next-active-buffer))

      (defun djr/rcirc-clear-screen ()
        (interactive)
        (rcirc-clear-unread (current-buffer))
        (endless/bury-buffer)))))

;;; packages.el ends here
