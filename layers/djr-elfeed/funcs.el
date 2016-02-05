(defun djr/elfeed-mark-all-read-in-buffer ()
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread)
  (elfeed-search-update :force))

(defun djr/elfeed-get-search-term-from-char (kar)
  (let* ((lookup '((?c . "+comic")
                   (?f . "+frequent")
                   (?h . "haskell")))
         (search (assoc-default kar lookup)))
    (concat "+unread " search)))

(defun djr/elfeed-limit ()
  "Shortcuts to often used filters"
  (interactive)
  (let* ((limit (read-char "Limit to ..."))
         (search (djr/elfeed-get-search-term-from-char limit)))
    (setq elfeed-search-filter search)
    (elfeed-search-update :force)))

(defun djr/elfeed-open-visible-in-browser ()
  "Opens all the visible feeds in the browser"
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-browse-url))
