(defun rrs (board)
        (interactive "sBoard id, plz: ")
        (let ((res (shell-command-to-string (concat "ssh str42.module.ru 'rrestart " board "'")))))
)

(defun rrx (board)
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
  (shell-command "cd ~/.emacs.d; proxychains git submodule update --init")
)


(message "Welcome to RC Module, dude!")

(setq url-proxy-services
       '(("http"     . "proxy:80")
         ("no_proxy" . "^.*\\(aventail\\|seanet\\)\.com")))


(make-frame-on-display ":1")