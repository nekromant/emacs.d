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

(add-to-list 'load-path "~/.emacs.d/doxymacs/lisp")
(require 'doxymacs)
(add-hook 'c-mode-common-hook'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
    (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
        (doxymacs-font-lock)))
  (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

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


; lua mode subrepo and stuff

(add-to-list 'load-path "~/.emacs.d/lua-mode/")
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

; popup module
(add-to-list 'load-path "~/.emacs.d/popup-el")   

; autocompletion

(add-to-list 'load-path "~/.emacs.d/auto-complete")    ; This may not be appeared if you have already added.
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)

(defalias 'ffk    'th-find-file-kio )
(defalias 'prof   'th-prof )
(defalias 'epush  'th-emacs-push)
(defalias 'epull  'th-emacs-pull)
(defalias 'reload 'th-reload)
(defalias 'uinf   'th-uisptool-info)
(defalias 'cx     'th-chmodx)
(defalias 'hdr    'th-c-header)


(read-extra-mode "php-mode" )
(read-extra-mode "kconfig"  )
