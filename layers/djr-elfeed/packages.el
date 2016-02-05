(defconst djr-elfeed-packages
  '())

(defun elfeed/pre-init-elfeed ()
  (spacemacs|use-package-add-hook elfeed
    :post-config
    (progn
      (bind-key "l" 'djr/elfeed-limit elfeed-search-mode-map)
      (bind-key "B" 'djr/elfeed-open-visible-in-browser elfeed-search-mode-map)
      (bind-key "b" 'elfeed-search-browse-url elfeed-search-mode-map)
      (bind-key "R" 'djr/elfeed-mark-all-read-in-buffer elfeed-search-mode-map))))

;;; packages.el ends here
