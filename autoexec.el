(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

; This sets c-mode style to linux kernel coding style
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              ;(when (and filename
              ;           (string-match (expand-file-name "~/src/linux-trees")
              ;                         filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))
)
;---

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


(defun th-reload()
  (interactive)
  (message "Rerunning autoexec")
  (load-file "~/.emacs.d/autoexec.el");
  )


(defun set_foxyproxy(state)
  (interactive "nS?:") 
  (shell-command "killall firefox")
  (if (= 1 state)
      (setq oldstate '0))
  (if (= 0 state)
      (setq oldstate '1))

					;(message "%d" oldstate)
  (let ((foxp
         (replace-regexp-in-string
          "[\n]+" ""
          (shell-command-to-string (concat "cat ~/.mozilla/firefox/profiles.ini|grep Path|cut -d\"=\" -f2")))))
    (message "Detected profile: " foxp)
    (message (concat "Setting firefox profile " foxp " proxy setting to %d" ) state))
  (shell-command (concat "sed -i 's/user_pref(\"network.proxy.type\", " (number-to-string oldstate) ")/user_pref(\"network.proxy.type\", " (number-to-string state) ")/g' ~/.mozilla/firefox/" foxp "/prefs.js" ))
  (shell-command "setsid firefox")
  ) 


(defun read-extra-mode(mode)
  (load-file (concat "~/.emacs.d/extramodes/" mode ".el" ))
)

(defun th-uisptool-info()
  (interactive)
  (shell-command "uisptool -i")
)


(defun th-spell-ru()
(interactive)
(setq flyspell-dictionary "russian")
(ispell-buffer)
)

(defun th-flyspell-en()
(interactive)
(setq flyspell-dictionary "english")
(ispell-buffer)
)

; chmod +x current buffer filename
(defun th-chmodx()
(interactive)
(shell-command (concat "chmod +x " buffer-file-name))
(message (concat "+x @ " buffer-file-name))
) 


(global-set-key [f10] 'th-flyspell-ru)
(global-set-key [f9]  'th-flyspell-en)

(defalias 'ffk    'th-find-file-kio )
(defalias 'prof   'th-prof )
(defalias 'epush  'th-emacs-push)
(defalias 'epull  'th-emacs-pull)
(defalias 'reload 'th-reload)
(defalias 'uinf   'th-uisptool-info)
(defalias 'cx     'th-chmodx)


(read-extra-mode "php-mode" )
(read-extra-mode "kconfig"  )
