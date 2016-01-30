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
