(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(add-to-list 'load-path
	     "~/.emacs.d/themes")

(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
;;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(setq x-select-enable-clipboard t) ; as above
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(setq c-default-style "linux")

(add-to-list 'load-path "~/.emacs.d/doxymacs/lisp")
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")

(require 'color-theme) ;;подгружаем "модуль раскраски"
(color-theme-initialize) ;;подгрузить библиотеку цветовых схем
(require 'color-theme-sweyla)
(color-theme-sweyla)



(require 'doxymacs)
(add-hook 'c-mode-common-hook'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)


(defun th-c-header(name)
  (interactive "sHeader name: ")
  (insert (concat "#ifndef __" name "_H\n"))
  (insert (concat "#define __" name "_H\n\n"))
  (insert "#endif\n")
  (forward-line -2)
  )


(setq th-ffk-path '"~")
(defun th-find-file-kio ()
  (interactive)
  (setq )
  
  (let ((file-name
         (replace-regexp-in-string
          "[\n]+" ""
          (shell-command-to-string (concat "kdialog --getopenurl " (concat "/" (buffer-file-name)) " 2> /dev/null")))))
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


(defun th-prof (prof)
  (interactive "sProfile, plz: ")
  (load-file (concat "~/.emacs.d/profiles/" prof ".el"))
  )

(th-prof "default")

(defun th-reload()
  (interactive)
  (message "Rerunning autoexec")
  (load-file "~/.emacs.d/init.el");
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


					;(require 'msf-abbrev) ;;подгружаем "режим сокращений"
					;(setq-default abbrev-mode t) ;;ставим его подифолту
					;(setq save-abbrevs nil) ;;не надо записывать в дефолтный каталог наши сокращения
					;(setq msf-abbrev-root "~/.emacs.d/abb") ;;надо записывать их сюда
					;(global-set-key (kbd "C-c a") 'msf-abbrev-define-new-abbrev-this-mode) ;;(Ctrl-c a) для создания нового сокращения
					;(msf-abbrev-load) ;;пусть этот режим будет всегда :)


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


(defun switch-to-minibuffer-window ()
  "switch to minibuffer window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

(global-set-key (kbd "s-x") 'switch-to-minibuffer-window)



(defun th-usb-string-descriptor(text)
  (interactive "sString, plz: ")
  (insert "{\n")
  (setq pos '2)
  (loop for x in (string-to-list text)
	do (insert (concat "'" (make-string 1 x) "', 0x0, "))
	(setq pos (+ 2 pos))
	)
  (insert " };")
  (beginning-of-line)
  (insert (format "0x%X,\n0x03,\n" pos))
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
(read-extra-mode "fill-column-indicator" )
(read-extra-mode "kconfig"  )
(read-extra-mode "php-electric")
(read-extra-mode "highlight-parentheses")
(read-extra-mode "mediawiki")
(read-extra-mode "tempo")
(read-extra-mode "smooth-scroll")

(read-extra-mode "git-commit-mode/git-commit")
(setq fci-rule-column 80)
(show-paren-mode)

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

(define-globalized-minor-mode global-show-paren-mode
  show-paren-mode
  (lambda ()
    (show-paren-mode t)))
(global-show-paren-mode t)
(php-electric-mode)

					;(setq visible-bell t)

(defun пыщ()
  (message "пыщ пыщ пыщ")
					; (let ((process-connection-type nil))  ; Use a pipe instead of pty
					;     (shell-command-to-string "ogg123 /usr/share/sounds/KDE-Im-Message-In.ogg >/dev/null&"))
  )
(setq ring-bell-function 'пыщ)


(defun th-open-aeel ()
  (interactive)
  (find-file "~/.emacs.d/autoexec.el")
  )

(defalias 'emd 'th-open-aeel)

(global-set-key "\C-g" 'goto-line)
(global-set-key "\C-b" 'ibuffer)
(global-set-key "\C-f" 'search-forward)
(global-set-key "\C-r" 'search-backward)
(global-set-key "\C-o" 'ffk)

(defun refresh-file ()
  (interactive)
  (revert-buffer t t t)
  )

(global-set-key [f5] 'refresh-file)


(global-set-key [M-up] 'beginning-of-defun)
(global-set-key [M-down] 'end-of-defun)

(server-start)

(defun th-yakuake-newsession(title)
  (message (shell-command-to-string "qdbus org.kde.yakuake /yakuake/sessions org.kde.yakuake.addSession"))
  )

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

;; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

(add-hook 'git-commit-mode-hook 'turn-on-flyspell)
(add-hook 'git-commit-mode-hook (lambda () (toggle-save-place 0)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


