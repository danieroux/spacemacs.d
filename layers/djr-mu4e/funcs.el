(defun djr/mu4e-inbox ()
  (interactive)

  (setq mu4e-headers-include-related nil
        mu4e~headers-sort-field :date
        mu4e~headers-sort-direction 'ascending)

  (mu4e-headers-search djr-mu4e-combined-inbox-bookmark))

(defun djr/mu4e-view-related-search (msg)
  "Search for related messages to the current one"
  (let* ((msgid (mu4e-msg-field msg :message-id)))
    (setq mu4e-headers-include-related t)
    (mu4e-headers-search (concat "msgid:" msgid))))

(defun djr/mu4e-mark-thread-as-read ()
  (interactive)
  (mu4e-headers-mark-thread-using-markpair '(read)))

(defun djr/mu4e-open-message-in-google (msg)
  (let* ((msgid (mu4e-message-field msg :message-id))
         (url (concat "https://mail.google.com/mail/u/0/?shva=1#search/rfc822msgid%3A"
                      (url-encode-url msgid))))
    (start-process "" nil "open" url)))

;; http://www.emacswiki.org/emacs/FlySpell#toc5
(defun fd-switch-dictionary()
  (interactive)
  (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "afrikaans") "english" "afrikaans")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)))
