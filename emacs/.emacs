(define-coding-system-alias 'utf8 'utf-8)

;; Local for Linux only.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Add package repositories.
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu elpa" . "https://elpa.gnu.org/packages/") t)

;; Refresh contents of all package repositories.
(package-initialize)
(unless
    package-archive-contents (package-refresh-contents))

;; Use use-package to install packages.
(dolist (package '(use-package))
  (unless (package-installed-p package)
     (package-install package)))

;; Always automatically ensure that packages are present.
(setq use-package-always-ensure t)

;; Font settings.
(set-frame-font "Dejavu Sans Mono")
(set-face-attribute 'default nil :family "Dejavu Sans Mono")
(set-face-attribute 'default nil :foundry "outline")
(set-face-attribute 'default nil :height 100)

;; Put custom settings in its own file.
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

;; Overflow into the next line instead of scrolling horizontally.
(put 'scroll-left 'disabled nil)

;; Don't truncate lines.
(setq-default truncate-lines t)

;; No bell sound.
(setq ring-bell-function 'ignore)

;; Remove UI clutter.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Backup to Emacs_Backup in $HOME.
(setq backup-directory-alist '(("." . "~/Emacs_Backup")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/Emacs_Backup" t)))

;; Color theme.
(use-package gruvbox-theme
  :config (load-theme 'gruvbox-dark-hard t)
  :ensure t)

;; Helm, needed to find the other packages, apparently.
(use-package helm
  :bind (("C-x b" . helm-mini)
	 ("M-x" . helm-M-x)
	 ("C-x M-f" . helm-find-files)
	 ("C-x C-b" . helm-buffers-list))
  :config
  (helm-mode 1)
  (setq helm-move-to-line-cycle-in-source nil)
  :ensure t)

;; Project handling.
(use-package projectile
  :config
  ;; Don't use elisp for indexing. Matters for very big projects.
  (setq projectile-indexing-method 'hybrid)
  (setq projectile-enable-caching t)
  (setq projectile-mode-line "Projectile")
  ;; Enable by default.
  (projectile-mode 1)
  :ensure t)

(use-package helm-projectile
  :bind (("C-c C-p" . helm-projectile-switch-project)
	 ("C-x C-f" . helm-projectile-find-file))
  :config (helm-projectile-on)
  :ensure t)

;; Popwin to get rid of *Help* windows etc. with a small popup window.
(use-package popwin
  :config (popwin-mode 1)
  :ensure t)

(add-to-list 'display-buffer-alist
  `(,(rx bos "*helm" (* not-newline) "*" eos)
    (display-buffer-in-side-window)
    (inhibit-same-window . t)
    (window-height . 0.4)))

(push '("*Backtrace*") popwin:special-display-config)
(push '("*Warnings*") popwin:special-display-config)
(push '("*compilation*" :height 40) popwin:special-display-config)

;; Scroll window five lines from the bottom instead.
(use-package smooth-scrolling
  :config
  (setq-default redisplay-dont-pause t
		scroll-conservatively 10000
		scroll-step 1
		scroll-margin 1
		scroll-preserve-screen-position 1)
  (smooth-scrolling-mode 1)
  :ensure t)

;; C-q will expand a region for marking, specifically regions within brackets.
(use-package expand-region
  :bind (("C-q" . er/expand-region))
  :ensure t)

;; Automatically create pairs of brackets.
(electric-pair-mode 1)

;; Multiple cursors.
(use-package multiple-cursors
  :bind (("C-j" . mc/mark-next-like-this)
	 ("C-S-j" . mc/mark-previous-like-this)))

;; ivy-mode. Mostly used for counsel-ag and swiper, using helm elsewhere.
(use-package swiper)
(use-package counsel)
(use-package ivy
  :config (ivy-mode 1))

(bind-key* (kbd "s-a") 'counsel-ag)
(bind-key* (kbd "ª") 'counsel-ag)
(bind-key* (kbd "C-s") 'swiper-isearch)
(bind-key* (kbd "C-r") 'swiper-isearch)

(setq-default ivy-height 30)

;; Show git diff of current file.
(use-package git-gutter
  :config (global-git-gutter-mode +1))

;; Use my own $PATH.
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Visual regex query-replace.
(use-package visual-regexp
  :ensure t
  :bind
  (("C-c C-r" . vr/query-replace)))

;; Format of the mode-line. Pretty minimalistic for now.
(setq-default mode-line-format
    '("%e"
     "%&"
     mode-line-front-space
     mode-line-buffer-identification
     "%l" ":" "%c"
     "   "
     mode-line-misc-info
     mode-line-end-spaces))
(which-function-mode)

;; Red trailing whitespace.
(setq-default show-trailing-whitespace t)

;; Inhibit startup screen.
(setq-default inhibit-startup-screen t)

;; Everything LSP related.
(use-package lsp-mode
  :config
  (setq lsp-signature-mode t
	lsp-log-io nil
	lsp-idle-delay 0.500
	lsp-completion-provider :capf
	lsp-auto-guess-root t
	lsp-enable-on-type-formatting nil
	lsp-enable-indentation nil
	lsp-before-save-edits nil
	lsp-semantic-tokens-mode t
	lsp-enable-symbol-highlighting nil
	lsp-lens-enable nil
	lsp-modeline-code-actions-enable nil
	lsp-eldoc-enable-hover nil)
  :commands lsp)

(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-enable t
	lsp-ui-sideline-show-symbol nil
	lsp-ui-sideline-show-hover nil
	lsp-ui-doc-enable nil
	lsp-ui-peek-show-directory t
	lsp-ui-peek-always-show t
	lsp-ui-peek-peek-height 40
	lsp-ui-doc-enable nil
	lsp-ui-doc-show-with-cursor nil
	lsp-ui-doc-show-with-mouse nil
	lsp-ui-sideline-enable nil
	lsp-ui-sideline-show-code-actions nil)
  :bind
  (("C-t" . lsp-ui-peek-find-definitions)
   ("C-M-t" . lsp-ui-peek-find-references)))

;; We want xrefs in a nice popwin, not replacing another buffer.
(use-package helm-xref
  :config (setq xref-show-xrefs-function 'helm-xref-show-xrefs))

;; ccls.
(use-package ccls
  :config
  (setq ccls-executable "ccls")
  (setq ccls-extra-init-params '(:index (:comments 0))))

;; General LSP stuff.
(defun my-lsp-ui-mode-hook ()
  :config
  (lsp-ui-peek-enable t)
  (lsp-ui-mode))
(add-hook 'lsp-mode-hook 'my-lsp-ui-mode-hook)

;; Pretty child frames.
(use-package posframe)
(defvar lsp-ui-peek--buffer nil)
(defun lsp-ui-peek--peek-display (src1 src2)
  (-let* ((win-width (frame-width))
          (lsp-ui-peek-list-width (/ (frame-width) 2))
          (string (-some--> (-zip-fill "" src1 src2)
                    (--map (lsp-ui-peek--adjust win-width it) it)
                    (-map-indexed 'lsp-ui-peek--make-line it)
                    (-concat it (lsp-ui-peek--make-footer))))
          )
    (setq lsp-ui-peek--buffer (get-buffer-create " *lsp-peek--buffer*"))
    (posframe-show lsp-ui-peek--buffer
                   :string (mapconcat 'identity string "")
                   :min-width (frame-width)
                   :poshandler #'posframe-poshandler-frame-center)))
(defun lsp-ui-peek--peek-destroy ()
  (when (bufferp lsp-ui-peek--buffer)
    (posframe-delete lsp-ui-peek--buffer))
  (setq lsp-ui-peek--buffer nil
        lsp-ui-peek--last-xref nil)
  (set-window-start (get-buffer-window) lsp-ui-peek--win-start))
(advice-add #'lsp-ui-peek--peek-new :override #'lsp-ui-peek--peek-display)
(advice-add #'lsp-ui-peek--peek-hide :override #'lsp-ui-peek--peek-destroy)

;; Languages.
(add-hook 'python-mode-hook 'lsp-deferred)
(add-hook 'code-mode-common-hook #'lsp)
(add-hook 'c-mode-common-hook #'lsp)

;; Autocomplete stuff.
(use-package company)

(eval-after-load 'company
  '(define-key company-active-map (kbd "C-n") 'company-select-next))
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-p") 'company-select-previous))

(setq company-idle-delay 0.0)
(setq company-minimum-prefix-length 3)
(setq company-dabbrev-downcase t)

(setq completions-format 'one-column)
(setq completions-header-format nil)
(setq completions-max-height 20)
(setq completion-auto-select nil)

(add-hook 'c-mode-common-hook 'company-mode)
(add-hook 'cpp-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)

;; Warnings.
(setq comp-async-report-warnings-errors nil)
(setq warning-minimum-level :error)
(setq byte-compile-warnings '(cl-functions))

;; Symbol overlaying.
(use-package symbol-overlay
  :ensure t
  :bind
  (("C-c i" . symbol-overlay-put)
   ("C-c o" . symbol-overlay-remove-all)))

;; magit.
(use-package magit
  :ensure t
  :bind
  (("C-M-m" . magit-blame-addition)))

;; clang-format stuff.
(use-package clang-format
  :config)

(defun my-clang-format-save-hook ()
  (when (member major-mode '(c++-mode c-mode))
    (clang-format-buffer)))
(add-hook 'before-save-hook 'my-clang-format-save-hook)

;; Rename a file.
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
        (filename (buffer-file-name))
        (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)

;; Default column-width of 120.
(setq-default fill-column 120)

;; Indentation for C/C++/GLSL.
(defvaralias 'c-basic-offset 'tab-width)
(defun c-mode-indentation ()
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode 1))
(add-hook 'c-mode-hook 'c-mode-indentation)
(add-hook 'c++-mode-hook 'c-mode-indentation)
(add-hook 'glsl-mode-hook 'c-mode-indentation)

;; Save position in registers to use like bookmarks.
(defun iregister-last-marker()
  (interactive)
  (setq iregister-current-marker-register 0)
  (iregister-jump-to-previous-marker))

(use-package iregister
  :bind
  ("s-c" . iregister-point-to-register)
  ("s-v" . iregister-last-marker)
  ("©" . iregister-point-to-register)
  ("“" . iregister-last-marker))

(bind-key* (kbd "M-,") 'iregister-last-marker)

;; Flycheck.
(use-package flycheck)
(setq flycheck-check-syntax-automatically '(mode-enabled save))

;; Everything keybind related should go below here.
(require 'bind-key)

;; M-n, M-p for next/previous window.
(defun prev-window ()
  (interactive)
  (other-window -1))
(bind-key* "M-n" 'other-window)
(bind-key* "M-p" 'prev-window)

;; Move to next/previous blank line.
(defun previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace."
  (interactive)
  (search-backward-regexp "^[ \t]*\n"))

(defun next-blank-line ()
  "Moves to the next line containing nothing but whitespace."
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1))

;; Replace moving between paragraphs with moving between blank lines.
(bind-key* (kbd "M-e") 'next-blank-line)
(bind-key* (kbd "M-q") 'previous-blank-line)

;; Compilation.
(setq compilation-scroll-output t)

;; I don't want any copilot stuff.
(setq lsp-copilot-applicable-fn (-const nil))

;; Misc. rebindings.
(bind-key* (kbd "s-d") 'undo)
(bind-key* (kbd "ð") 'undo)
(bind-key* (kbd "s-f") 'forward-to-word)
(bind-key* (kbd "đ") 'forward-to-word)
(bind-key* (kbd "s-b") 'backward-to-word)
(bind-key* (kbd "”") 'backward-to-word)
(bind-key* (kbd "C-l") 'recenter)
(bind-key* (kbd "C-M-p") 'goto-line)
(bind-key* (kbd "C-M-i") 'compile)
(bind-key* (kbd "C-M-r") (lambda() (interactive) (compile "cd /home/tms/dev/lax/build && make -j16 && ./bin/editor")))
(bind-key* (kbd "C-M-w") (lambda() (interactive) (compile "cd build && make -j16 && cd ./bin && PLAYGROUND=1 ./unhurried")))
(bind-key* (kbd "C-M-c") (lambda() (interactive) (compile "cd /home/tms/dev/lax/build && make -j16")))
(bind-key* (kbd "ø") (kbd "{"))
(bind-key* (kbd "æ") (kbd "}"))
(bind-key* (kbd "Ø") (kbd "("))
(bind-key* (kbd "Æ") (kbd ")"))
(bind-key* (kbd "Æ") (kbd ")"))
(bind-key* (kbd "s-e") (kbd "["))
(bind-key* (kbd "€") (kbd "["))
(bind-key* (kbd "s-r") (kbd "]"))
(bind-key* (kbd "®") (kbd "["))
(bind-key* (kbd "@") (lambda () (interactive) (insert "'")))
(bind-key* (kbd "s-2") (lambda () (interactive) (insert "@")))
(bind-key* (kbd "C-ø") (lambda () (interactive) (insert "\\")))
(bind-key* (kbd "M-c") 'comment-region)
(bind-key* (kbd "C-x M-c") 'uncomment-region)
(bind-key* (kbd "s-t") 'ff-find-other-file)
(bind-key* (kbd "þ") 'ff-find-other-file)
(bind-key* (kbd "C-c C-n") 'flycheck-next-error)
(bind-key* (kbd "<left>") 'xref-pop-marker-stack)
(bind-key* (kbd "<right>") 'xref-go-forward)
(bind-key* (kbd "C-M-e") 'end-of-defun)
(bind-key* (kbd "C-M-q") 'beginning-of-defun)
(bind-key* (kbd "M-y") 'helm-show-kill-ring)

