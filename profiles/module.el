(defun th-rr (board)
        (interactive "sBoard id, plz: ")
        (let ((res (shell-command-to-string (concat "ssh str42.module.ru 'rrestart " board "'")))))
)

(defalias 'rr 'th-rr )
(message "Welcome to rc module, dude!")