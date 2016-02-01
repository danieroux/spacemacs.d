(defconst djr-mu4e-packages
  '((mu4e :location built-in)
    (mu4e-contrib :location built-in)
    org-mu4e
    s
    (djr-org-mu4e :location local)
    (djr-mu4e-mbsync :location local)
    (smtpmail :location built-in)))

(defun djr-mu4e/init-mu4e-contrib ()
  (use-package mu4e-contrib))

(defun djr-mu4e/init-djr-mu4e-mbsync ()
  (use-package djr-mu4e-mbsync))

(defun djr-mu4e/pre-init-mu4e ()
  (defvar djr-mu4e-combined-inbox-bookmark "(maildir:/INBOX OR maildir:/[Gmail]/.Starred) AND NOT flag:trashed" "What I consider to be my 'inbox'")

  (setq mu4e-bookmarks `((,djr-mu4e-combined-inbox-bookmark                         "Act-on inbox"                  ?i)
                         ("flag:unread AND NOT maildir:/me AND NOT flag:trashed"    "Unread messages"               ?v)
                         ("maildir:/INBOX AND flag:unread AND NOT flag:trashed"     "Unread to me"                  ?m)
                         ("maildir:/INBOX AND flag:replied AND NOT flag:trashed"    "Replied to me"                 ?r)
                         ("mime:application/pdf AND NOT flag:thrashed"              "Messages with PDFs"            ?p)))

  (setq mu4e-maildir (expand-file-name "~/Mail"))
  (setq mu4e-drafts-folder "/[Gmail]/.Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/.Sent Mail")

  ;; don't save message to Sent Messages, GMail/IMAP will take care of this
  (setq mu4e-sent-messages-behavior 'delete)

  ;; setup some handy shortcuts
  ;; More shortcuts (with email addresses) in private.el
  (setq mu4e-maildir-shortcuts
        `((,mu4e-drafts-folder    . ?d)))

  ;; Not synced
  (setq mu4e-trash-folder  "/not-really-trash")
  (setq mu4e-refile-folder "/gtd")

  (setq mu4e-get-mail-command "true")

  (when (spacemacs/system-is-mac)
    (progn
      (setq mu4e-mu-binary "/usr/local/bin/mu"
            mail-host-address "danie-notebook")))

  (setq mu4e-use-fancy-chars nil
        mu4e-attachment-dir "~/Desktop"
        mu4e-headers-results-limit 100
        mu4e-headers-skip-duplicates t
        mu4e-headers-leave-behavior 'apply
        mu4e-view-show-images t
        mu4e-view-image-max-width 800
        mu4e-view-show-addresses t
        mu4e-headers-fields '((:human-date . 12) (:from-or-to . 22) (:subject))
        message-kill-buffer-on-exit t)

  (setq mu4e-html2text-command 'mu4e-shr2text)
  (setq mu4e-view-show-images t)

  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  (spacemacs|use-package-add-hook mu4e
    :post-config
    (progn
      (add-to-list 'mu4e-view-actions '("gopen in gmail" . djr/mu4e-open-message-in-google) t)
      (add-to-list 'mu4e-view-actions '("rview related" . djr/mu4e-view-related-search) t)
      (add-to-list 'mu4e-view-actions '("bview in browser" . mu4e-action-view-in-browser) t)

      ;; mu4e~view-copy-contact c or C-c
      (add-hook 'mu4e-view-mode-hook 'goto-address-mode)
      (add-hook 'mu4e-compose-mode-hook 'turn-off-auto-fill)

      (add-hook 'mu4e-headers-mode-hook
                (lambda ()
                  (define-key mu4e-headers-mode-map "r" 'djr/mu4e-compose-reply-with-follow-up)
                  (define-key mu4e-headers-mode-map "M" 'mu4e~main-toggle-mail-sending-mode)
                  ;; If I go to the next message, it means I want the current thread as read.
                  (define-key mu4e-headers-mode-map "n" 'djr/mu4e-mark-thread-as-read)
                  (define-key mu4e-headers-mode-map "d" 'mu4e-headers-mark-for-delete)
                  (define-key mu4e-headers-mode-map "f" 'djr/mu4e-forward-with-follow-up)))

      (add-hook 'mu4e-view-mode-hook
                (lambda ()
                  (define-key mu4e-view-mode-map "r" 'djr/mu4e-compose-reply-with-follow-up)
                  (define-key mu4e-view-mode-map "M" 'mu4e~main-toggle-mail-sending-mode)
                  (define-key mu4e-view-mode-map "d" 'mu4e-view-mark-for-delete)
                  (define-key mu4e-view-mode-map "f" 'djr/mu4e-forward-with-follow-up)))

      (remove-hook 'text-mode-hook 'turn-on-auto-fill))))

(defun djr-mu4e/post-init-mu4e ()
  (evil-set-initial-state 'mu4e-headers-mode 'emacs)
  (evil-set-initial-state 'mu4e-view-mode 'emacs))

(defun djr-mu4e/init-smtpmail ()
  (use-package smtpmail
    :commands (smtpmail-send-queued-mail message-send-and-exit)

    :init
    ;; Authentication is handled by ~/.authinfo.gpg with this format:
    ;; machine smtp.gmail.com login USER@gmail.com password PASSWORD port 465
    (setq message-send-mail-function 'smtpmail-send-it
          sendmail-coding-system 'utf-8
          mm-coding-system-priorities '(utf-8)
          smtpmail-stream-type 'ssl
          smtpmail-smtp-server "smtp.gmail.com"
          message-user-fqdn "danieroux.com"
          mail-user-agent 'mu4e-user-agent
          smtpmail-smtp-service 465

          smtpmail-queue-mail t
          smtpmail-queue-dir (concat mu4e-maildir "/mu4e-queue"))))
