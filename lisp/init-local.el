;; Save emacs backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; Disk space is cheap, save lots
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Custom theme
(setq custom-theme-directory "~/.emacs.d/theme")
(defun my-load-theme (&optional frame)
  (with-selected-frame (or frame (selected-frame))
    (load-theme 'my-solarized t)))
(my-load-theme)
(add-hook 'after-make-frame-functions 'my-load-theme)
(setq custom-safe-themes t)
(setq x-gtk-use-system-tooltips nil)


;;; define categories that should be excluded
(setq org-export-exclude-category (list "google" "private"))

;;; define filter. The filter is called on each entry in the agenda.
;;; It defines a regexp to search for two timestamps, gets the start
;;; and end point of the entry and does a regexp search. It also
;;; checks if the category of the entry is in an exclude list and
;;; returns either t or nil to skip or include the entry.

(defun org-mycal-export-limit ()
  "Limit the export to items that have a date, time and a range. Also exclude certain categories."
  (setq org-tst-regexp "<\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\} ... [0-9]\\{2\\}:[0-9]\\{2\\}[^\r\n>]*?\
\)>")
  (setq org-tstr-regexp (concat org-tst-regexp "--?-?" org-tst-regexp))
  (save-excursion
                                        ; get categories
    (setq mycategory (org-get-category))
                                        ; get start and end of tree
    (org-back-to-heading t)
    (setq mystart    (point))
    (org-end-of-subtree)
    (setq myend      (point))
    (goto-char mystart)
                                        ; search for timerange
    (setq myresult (re-search-forward org-tstr-regexp myend t))
                                        ; search for categories to exclude
    (setq mycatp (member mycategory org-export-exclude-category))
                                        ; return t if ok, nil when not ok
    (if (and myresult (not mycatp)) t nil))):

;;; activate filter and call export function
(defun org-mycal-export ()
  (let ((org-icalendar-verify-function 'org-mycal-export-limit))
    (org-export-icalendar-combine-agenda-files)))
(setq a 3)

;; If you want to export also TODO items that have a SCHEDULED timestamp, you can set
;; (setq org-icalendar-use-scheduled '(todo-start event-if-todo))

;; Enable linum-mode globally, except for when org-mode is active
;;(add-hook 'org-mode-hook
;;(lambda ()
;;(linum-mode 1)
;;))
;; Add specific folders to my org-mode agenda
;; (setq org-agenda-files (quote ("~/personal/org-agenda")))


(require 'init-my-org-mode)


;; Needed by init.el
;; Must be last line of the file
(provide 'init-local)
