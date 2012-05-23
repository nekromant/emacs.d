(setq th-ffk-path '"~")

(defun th-find-file-kio ()
  (interactive)
  (let ((file-name
         (replace-regexp-in-string
          "[\n]+" ""
          (shell-command-to-string (concat "kdialog --getopenurl " th-ffk-path " 2> /dev/null")))))
    (message file-name)
    (cond
     ((string-match "^file://" file-name)
      ;; Work arround a bug in kioexec, which causes it to delete local
      ;; files. (See bugs.kde.org, Bug 127894.) Because of this we open the
      ;; file with `find-file' instead of emacsclient.
      (let ((local-file-name (substring file-name 7)))
        (message "Opening local file '%s'" local-file-name)
	(setq th-ffk-path local-file-name )
        (find-file local-file-name)))
     ((string-match "^[:space:]*$" file-name)
      (message "Empty file name given, doing nothing..."))
     (t
      (message "Opening remote file '%s'" file-name)
      (save-window-excursion
        (shell-command (concat "kioexec emacsclient " file-name "&"))))))
  )

(defun th-emacs-push()
  (interactive)
  (shell-command (concat "cd ~/.emacs.d; git commit -a -m \"Autocommit from emacs\"; git push"))
  )

(defun th-emacs-pull()
  (interactive)
  (shell-command "cd ~/.emacs.d; git pull;")
  )

(defun th-prof (prof)
  (interactive "sProfile, plz: ")
  (load-file (concat "~/.emacs.d/profiles/" prof ".el"))
  )


(defalias 'ffk    'th-find-file-kio )
(defalias 'prof   'th-prof )
(defalias 'epush  'th-emacs-push)
(defalias 'epull  'th-emacs-pull)