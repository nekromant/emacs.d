; We need to override th-sync to use proxychains
; or otherwise we're stuck for good

(defun th-emacs-push()
  (interactive)
  (shell-command (concat "cd ~/.emacs.d; git commit -a -m \"Autocommit from emacs\"; proxychains git push"))
)

(defun th-emacs-pull()
  (interactive)
  (shell-command "cd ~/.emacs.d; proxychains git pull --recurse-submodules=on;")
)

(message "Welcome to IAC, dude!")