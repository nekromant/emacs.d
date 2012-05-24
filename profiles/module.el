(defun th-rr (board)
        (interactive "sBoard id, plz: ")
        (let ((res (shell-command-to-string (concat "ssh str42.module.ru 'rrestart " board "'")))))
)

; We need to override th-sync to use proxychains
; or otherwise we're stuck

(defun th-emacs-push()
  (interactive)
  (shell-command (concat "cd ~/.emacs.d; git commit -a -m \"Autocommit from emacs\"; proxychains git push"))
)

(defun th-emacs-pull()
  (interactive)
  (shell-command "cd ~/.emacs.d; proxychains git pull --recurse-submodules=on;")
)


(defalias 'rr 'th-rr )

(message "Welcome to RC Module, dude!")