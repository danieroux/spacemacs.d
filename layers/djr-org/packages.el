(defconst djr-org-packages
  '(org (org-crypt :location built-in)))

(defun djr-org/post-init-org ()
  (org-clock-persistence-insinuate)

  (setq org-modules (quote (org-habit)))

  (use-package org-mac-link)

  ;; Files
  (setq gtd-file "~/Dropbox/Documents/gtd/gtd.org.gpg"
        consulting-file "~/Dropbox/Documents/consulting/consulting.org.gpg"
        inbox-file "~/Dropbox/Documents/gtd/inbox.org"
        someday-file "~/Dropbox/Documents/gtd/someday_maybe.org.gpg"
        brain-file "~/Dropbox/Documents/brain/brain.org.gpg"
        conversations-file "~/Dropbox/Documents/gtd/conversations.org"
        period-log-file "~/Dropbox/Documents/journal/period.org.gpg"
        blog-ideas-file "~/Dropbox/Documents/gtd/blog_ideas.org.gpg")

  (setq org-agenda-files `( ;; "~/Dropbox/Documents"
                           ;; "~/Dropbox/Documents/gtd"
                           ;; ,brain-file
                           ,gtd-file
                           ,consulting-file
                           ))

  (setq org-directory "~/Dropbox/Documents/gtd")

  (setq org-blank-before-new-entry nil
        org-enforce-todo-dependencies t
        org-fast-tag-selection-include-todo t
        org-fast-tag-selection-single-key t
        org-use-fast-todo-selection t
        org-treat-S-cursor-todo-selection-as-state-change nil
        org-hide-leading-stars t
        org-agenda-skip-additional-timestamps-same-entry nil
        org-id-method (quote uuidgen)
                                        ; Make clocktable indents pretty-ish
        org-pretty-entities t
        org-id-link-to-org-use-id t)

  ;; Todo config
  (setq org-todo-keywords (quote ((sequence "NEXT(n)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(z) | NOTE(t)"))))

  (setq djr-single-task-header-id "C3478345-CEEF-497D-97EF-32AB278FBCF3")

  (setq org-capture-templates `(("P" "New Project" entry (file ,gtd-file) "* %^{Project name}
** NEXT %^{First task}%?")
                                ("b" "Brain" entry (file ,brain-file) "* %?
  %u

%a")
                                ("l" "liam" entry (file "~/Dropbox/Documents/liam.org") "* %?" :clock-in t :clock-resume t)
                                ("f" "Fieldstone" entry (file "~/Dropbox/Documents/gtd/stones.org") "* %?
  %u

%a")
                                ("i" "inbox" entry (file ,inbox-file) "* NEXT %?
  %u

%a")
                                ("S" "Someday/Maybe" entry (file ,someday-file) "* NEXT %?
  %u

%a")
                                ("I" "Pay Invoice" entry (id ,djr-single-task-header-id) "* NEXT %a :@banking:
  %u

%a")
                                ("R" "Read paper" entry (id "54B79B33-F158-4200-A317-83DE22D6E6B6") "* NEXT %a :@open:
  %u

%a")
                                ("s" "Single task" entry (id ,djr-single-task-header-id) "* NEXT %? %^g
  %u

%a")
                                ("e" "Follow up email" entry (id ,djr-single-task-header-id) "* NEXT %? %a                     :@online:
  %u
  SCHEDULED: %^t

%a")
                                ("n" "note" entry (file ,inbox-file) "* NOTE %?
  %u
%a")

                                ("d" "daily" entry (file ,period-log-file) "* %U

%?")
                                ("D" "dream" entry (file "~/Dropbox/Documents/journal/dream.org.gpg") "* %U

%?")
                                ("c" "The current Chrome tab" entry (file ,inbox-file) "* NEXT %? %(org-mac-chrome-get-frontmost-url)  :@online:
  %u

%a")))

  (setq org-stuck-projects
        '("+LEVEL=1+project-persistent/-DONE-CANCELLED" ("NEXT" "STARTED") ()))

  (setq org-tag-alist (quote ((:startgroup)
                              ("@errands" . ?e)
                              ("@banking" . ?b)
                              ("@calls" . ?c)
                              ("@home" . ?h)
                              ("@open" . ?O)
                              ("@notebook" . ?a)
                              ("@online" . ?o)
                              ("@agenda" . ?A)
                              ("@watch" . ?W)
                              (:endgroup)
                              ("crypt" . ?s)
                              ("drill" . ?D)
                              ("project" . ?P))))

  (setq org-agenda-tags-todo-honor-ignore-options t
        org-agenda-todo-ignore-scheduled 'future
        org-agenda-skip-function-global nil)

  (setq org-agenda-sorting-strategy
        '(time-up category-keep priority-down))

  (defun gtd-refile ()
    "Includes email and anything in an inbox"
    `(tags "refile" ((org-agenda-overriding-header "Inbox"))))

  (defun gtd-agenda ()
    `(agenda "-MAYBE" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("NEXT" "STARTED" "WAITING" "project"))))))

  (defun gtd-context (heading query-string)
    `(tags-todo ,(concat query-string "/!-DONE-CANCELLED-WAITING")
                ((org-agenda-overriding-header ,heading)
                 (org-tags-match-list-sublevels t)
                 (org-agenda-tags-todo-honor-ignore-options t)
                 (org-agenda-todo-ignore-scheduled 'future))))

  (defun gtd-project-context (tag &optional if-mode)
    (gtd-context tag (concat "+project+" tag if-mode)))

  (defun gtd-agenda-entry (key context-tag)
    `((,key ,context-tag ,@(gtd-project-context context-tag))))

  (setq org-agenda-custom-commands `(("H" "@home"
                                      (,(gtd-agenda)
                                       ,(gtd-project-context "@banking" "-consulting")
                                       ,(gtd-project-context "@home" "-consulting")
                                       ,(gtd-project-context "@open" "-consulting")
                                       ,(gtd-project-context "@online" "-consulting")
                                       ,(gtd-project-context "@notebook" "-consulting")
                                       ,(gtd-project-context "@calls" "-consulting")
                                       ,(gtd-project-context "@watch")
                                       ,(gtd-refile)))
                                     ("N" "@notebook"
                                      (,(gtd-agenda)
                                       ,(gtd-project-context "@banking")
                                       ,(gtd-project-context "@notebook")
                                       ,(gtd-project-context "@calls")
                                       ,(gtd-project-context "@open")
                                       ,(gtd-project-context "@online")
                                       ,(gtd-project-context "@errands")
                                       ,(gtd-project-context "@watch")
                                       ,(gtd-refile)))
                                     ("M" "Mobile"
                                      (,(gtd-agenda)
                                       ,(gtd-project-context "@open")
                                       ,(gtd-project-context "@calls")
                                       ,(gtd-project-context "@errands")
                                       ,(gtd-project-context "@online")
                                       ,(gtd-project-context "@banking")))
                                     ,@(gtd-agenda-entry "n" "@notebook")
                                     ,@(gtd-agenda-entry "e" "@errands")
                                     ,@(gtd-agenda-entry "o" "@online")
                                     ,@(gtd-agenda-entry "O" "@open")
                                     ,@(gtd-agenda-entry "A" "@agenda")
                                     ,@(gtd-agenda-entry "h" "@home")
                                     ,@(gtd-agenda-entry "b" "@banking")
                                     ,@(gtd-agenda-entry "c" "@calls")
                                     ,@(gtd-agenda-entry "W" "@watch")
                                     ("w" "Waiting" todo "WAITING" ((org-agenda-overriding-header "Waiting")))
                                     ("r" "refile" tags "refile" nil)
                                     ("p" "projects" tags "+LEVEL=1+project-persistent-@agenda-MAYBE/-CANCELLED-DONE" nil)
                                     ("E" "Todo items without context (in error)"
                                      ((tags "+project+TODO=\"NEXT\"-{@.*}"))
                                      ((org-agenda-overriding-header "context free")))))

  (defun djr/org-mode-refile-current-task-as-single-task ()
    "Refiles the current task as a single task in gtd.org"
    (interactive)
    (let* ((org-refile-targets `((,gtd-file . (:tag . "single"))))
           ;; Because the tag captures the top level to, grab the second entry
           (rfloc (nth 1 (org-refile-get-targets))))
      (org-refile nil nil rfloc)))


  (setq org-completion-use-ido t
        org-refile-targets `((,(remove brain-file org-agenda-files) :level . 1)
                             (,brain-file . (:level . 0))
                             (,period-log-file . (:level . 0))
                             (,someday-file . (:level . 0))
                             (,blog-ideas-file . (:level . 0))
                             (,conversations-file . (:level . 1))
                             (nil . (:level . 1)))
        org-refile-use-outline-path (quote file)
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes nil)


  (setq org-agenda-include-diary nil)
  (setq org-agenda-todo-ignore-scheduled 'future)

  (setq org-agenda-span 'day
        org-deadline-warning-days 5)

  (setq org-cycle-separator-lines 0
        org-log-done 'time)

  (setq org-src-fontify-natively t)
  (setq org-archive-default-command (quote org-archive-to-archive-sibling)
        org-archive-location "%s_archive.gpg::")

  ;; Dim blocked tasks
  (setq org-agenda-dim-blocked-tasks 'invisible)

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

  (setq org-enforce-todo-checkbox-dependencies t
        org-enforce-todo-dependencies t)

  (setq org-use-speed-commands t
        ;; Also see org-speed-commands-default
        org-speed-commands-user (quote (("0" . ignore)
                                        ("1" . ignore) ;; For org-drill
                                        ("2" . ignore)
                                        ("3" . ignore)
                                        ("4" . ignore)
                                        ("5" . ignore)
                                        ("d" . org-decrypt-entry)
                                        ("j" . ignore)
                                        ("J" . org-clock-goto)
                                        ("k" . ignore)
                                        ("K" . org-cut-special)
                                        ("N" . org-narrow-to-subtree)
                                        ("P" . org-pomodoro)
                                        ("q" . djr/show-org-agenda-refreshing-if-empty)
                                        ("s" . djr/org-mode-refile-current-task-as-single-task)
                                        ("z" . org-add-note)
                                        ("W" . widen))))

  (setq org-agenda-persistent-filter t)
  (setq org-clock-idle-time 5)

  (defun djr/show-org-agenda-refreshing-if-empty ()
    "If the Org Agenda buffer has been drawn, show it. Else refresh and show."
    (interactive)
    (if (or (not (get-buffer "*Org Agenda*"))
            (= 0 (buffer-size (get-buffer "*Org Agenda*"))))
        (djr/agenda-notebook))
    (switch-to-buffer "*Org Agenda*")
    (delete-other-windows)))

;;; packages.el ends here
