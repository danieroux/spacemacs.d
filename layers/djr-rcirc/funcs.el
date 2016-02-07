(defun djr/general-to-less-general-slack-channel-name ()
  (interactive)
  (rename-buffer
   (djr/general-to-less-general-slack-channel-name-1 (buffer-name))))

(defun djr/general-to-less-general-slack-channel-name-1 (a-buffer-name)
  "Turns #general@znc-slackserver into #slackserver-g@znc-slackserver, or leaves buffer-name the same"
  (if (s-starts-with? "#general" a-buffer-name)
      (let* ((server (second (s-split "@znc-" a-buffer-name))))
        (format "#%s-g@znc-%s" server server))
    a-buffer-name))

(defun djr/rcirc ()
  (interactive)
  (ignore-errors
    (async-shell-command "/usr/local/sbin/bitlbee -D"))
  (rcirc nil))

(defun spacemacs/rcirc-notify-beep (msg)
  "Override, beep when notifying with afplay"
  (let ((player "afplay")
        (sound (concat user-emacs-directory "site-misc/startup.ogg")))
    (when (and (executable-find player)
               (file-exists-p sound)))
    (start-process "beep-process" nil player sound)))

;;; Helm

(defun djr//rcirc-is-server-buffer-p (buf)
  (with-current-buffer buf rcirc-buffer-alist))

(defun djr//rcirc-chat-buffers ()
  (-filter
   (lambda (buf)
     (and
      (eq 'rcirc-mode (with-current-buffer buf major-mode))
      (not (djr//rcirc-is-server-buffer-p buf))))
   (buffer-list)))

;; Adapted from rcirc.el
(defun djr//rcirc-chat-buffers-sorted-by-last-activity ()
  (sort (djr//rcirc-chat-buffers)
        (lambda (b1 b2)
          (let ((t1 (with-current-buffer b1 rcirc-last-post-time))
                (t2 (with-current-buffer b2 rcirc-last-post-time)))
            (time-less-p t2 t1)))))

(defun djr//rcirc-buffer-names ()
  (mapcar (lambda (buffer)
            (cons (buffer-name buffer) buffer))
          (djr//rcirc-chat-buffers-sorted-by-last-activity)))

(setq djr-rcirc-buffers-source
      '((name . "RCIRC buffers")
        (candidates . djr//rcirc-buffer-names)
        (action . (lambda (buffer) (switch-to-buffer buffer)))))

(defun djr/helm-rcirc-buffers ()
  (interactive)
  (helm :sources 'djr-rcirc-buffers-source
        :prompt "RCIRC buffers: "))
