(defun th-emacs-push()
  (interactive)
  (shell-command (concat "cd ~/.emacs.d; git commit -a -m -s \"Autocommit from emacs\"; git push"))
  )

(defun th-emacs-pull()
  (interactive)
  (shell-command "cd ~/.emacs.d; git pull --recurse-submodules=on;")
  (shell-command "cd ~/.emacs.d; git submodule update --init")
  )

(shell-command "xrandr --auto")
(message "Default profile loaded")
