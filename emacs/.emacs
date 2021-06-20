(define-coding-system-alias 'utf8 'utf-8)

;; TLS 1.3.
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Add package repositories.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu elpa" . "https://elpa.gnu.org/packages/") t)

;; Refresh contents of all package repositories.
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Use use-package to install packages.
(dolist (package '(use-package))
  (unless (package-installed-p package)
     (package-install package)))

;; Always automatically ensure that packages are present.
(setq use-package-always-ensure t)

;; Add custom lisp to load path.
(add-to-list 'load-path (locate-user-emacs-file "lisp/"))

;; Font settings.
(set-frame-font "Dejavu Sans Mono")
(set-face-attribute 'default nil :family "Dejavu Sans Mono")
(set-face-attribute 'default nil :foundry "outline")
(set-face-attribute 'default nil :height 98)

;; Put custom settings in its own file.
(setq custom-file (concat user-emacs-directory "custom.el"))

;; M-n, M-p for next/previous window.
(defun prev-window ()
  (interactive)
  (other-window -1))
(bind-key* "M-n" 'other-window)
(bind-key* "M-p" 'prev-window)

;; Automatically create pairs of brackets.
(electric-pair-mode 1)

;; Overflow into the next line instead of scrolling horizontally.
(put 'scroll-left 'disabled nil)

;; Remove UI clutter.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Backup to Emacs_Backup in $HOME.
(setq backup-directory-alist '(("." . "~/Emacs_Backup")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/Emacs_Backup" t)))

;; Forward-word should respect camel casing.
(add-hook 'prog-mode-hook 'subword-mode)

;; Key binds for [un]commenting regions.
(global-set-key (kbd "M-c") 'comment-region)
(global-set-key (kbd "C-x M-c") 'uncomment-region)

;; Color theme.
(use-package gruvbox-theme
  :config (load-theme 'gruvbox-dark-hard t))

;; C/C++ stuff. Access labels like public/private/protected.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(c-set-offset 'access-label '-)

;; Hop between .cpp and .h.
(global-set-key (kbd "þ") 'ff-find-other-file)

;; Indentation for C/C++/GLSL.
(defvaralias 'c-basic-offset 'tab-width)
(defun c-mode-indentation ()
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode true))
(add-hook 'c-mode-hook 'c-mode-indentation)
(add-hook 'c++-mode-hook 'c-mode-indentation)
(add-hook 'glsl-mode-hook 'c-mode-indentation)

;; Folding for C++.
(bind-key* "C-c C-j" 'hs-hide-block)
(bind-key* "C-c C-k" 'hs-show-block)

;; Shader file endings.
(add-to-list 'auto-mode-alist '("\\.vert\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.comp\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.tese\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.tesc\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . c-mode))

;; Helm selection narrowing.
(use-package helm-config
  :bind (("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("M-x" . helm-M-x)
	 ("C-x M-f" . helm-find-files)
     ("C-x C-b" . helm-buffers-list))
  :config (helm-mode 1))

(setq x-wait-for-event-timeout nil)
(setq helm-buffer-max-length nil)

;; Project handling.
(use-package projectile
  :ensure t
  :config
  (projectile-mode 1)

  ;; Don't use elisp for indexing. Matters for very big projects.
  (setq projectile-indexing-method 'hybrid)
  (setq projectile-enable-caching t)
  (setq projectile-mode-line "Projectile"))

(use-package helm-projectile
  :bind (("C-c C-p" . helm-projectile-switch-project)
	 ("C-x C-f" . helm-projectile-find-file))
  :config (helm-projectile-on))

;; Popwin to get rid of *Help* windows etc. with a small popup window.
(use-package popwin
  :config (popwin-mode 1))

(add-to-list 'display-buffer-alist
  `(,(rx bos "*helm" (* not-newline) "*" eos)
    (display-buffer-in-side-window)
    (inhibit-same-window . t)
    (window-height . 0.4)))

;; Scroll window five lines from the bottom instead.
(use-package smooth-scrolling
  :config
  (smooth-scrolling-mode 1)
  (setq-default redisplay-dont-pause t
				scroll-conservatively 10000
				scroll-step 1
				scroll-margin 1
				scroll-preserve-screen-position 1))

;; C-q will expand a region for marking, specifically regions within brackets.
(use-package expand-region
  :bind (("C-q" . er/expand-region)))

;; Emacs Rocks!
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C-j" . mc/mark-next-like-this)
	 ("C-S-j" . mc/mark-previous-like-this)))

;; Move to next/previous blank line.
(defun previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace."
  (interactive)
  (search-backward-regexp "^[ \t]*\n")
  )

(defun next-blank-line ()
  "Moves to the next line containing nothing but whitespace."
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1)
  )

;; Replace moving between paragraphs with moving between blank lines.
(global-set-key (kbd "M-e") 'next-blank-line)
(global-set-key (kbd "M-q") 'previous-blank-line)

(bind-key* (kbd "C-M-e") 'end-of-defun)
(bind-key* (kbd "C-M-q") 'beginning-of-defun)

;; Misc. rebindings. This uses AltGr combinations to free keys.
(global-set-key (kbd "ø") (kbd "{"))
(global-set-key (kbd "æ") (kbd "}"))
(global-set-key (kbd "Ø") (kbd "("))
(global-set-key (kbd "Æ") (kbd ")"))
(global-set-key (kbd "€") (kbd "["))
(global-set-key (kbd "®") (kbd "]"))
(global-set-key (kbd "å") (kbd "/"))
(global-set-key (kbd "ð") 'undo)
(global-set-key (kbd "C-ø") 'subword-backward-kill)
(global-set-key (kbd "C-c C-r") 'query-replace)
(global-set-key (kbd "C-M-r") 'query-replace-regexp)
(global-set-key (kbd "C-M-o") 'newline)
(global-set-key (kbd "C-M-f") 'describe-buffer-file-name)
(global-set-key (kbd "C-M-m") 'magit-blame-addition)

(bind-key* (kbd "C-c C-n") 'flycheck-next-error)

(bind-key* (kbd "C-c C-c") 'copy-to-register)
(bind-key* (kbd "C-c C-v") 'insert-register)

(bind-key* (kbd "½") (kbd "|"))

;; ivy-mode. Mostly used for counsel-ag and swiper, using helm elsewhere.
(use-package swiper)
(use-package counsel)
(use-package ivy
  :config (ivy-mode 1))

;; counsel-grep-or-ag is replaced with swiper-isearch for start-up speed.
(global-set-key (kbd "ª") 'counsel-ag)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-isearch)

(setq-default ivy-height 30)

;; Key bind scrolling up and down _in place_ without moving the cursor.
(defun scroll-in-place (scroll-up)
  "Scroll window up (or down) without moving point (if possible).

SCROLL-Up is non-nil to scroll up one line, nil to scroll down."
  (interactive) 
  (let ((pos (point))
                (col (current-column))
                (up-or-down (if scroll-up 1 -1)))
        (scroll-up up-or-down)
        (if (pos-visible-in-window-p pos)
                (goto-char pos)
          (if (or (eq last-command 'next-line)
                          (eq last-command 'previous-line))
                  (move-to-column temporary-goal-column)
                (move-to-column col)
                (setq temporary-goal-column col))
          (setq this-command 'next-line))))

(defun scroll-up-in-place ()
  "Scroll window up without moving point (if possible)."
  (interactive)
  (scroll-in-place t))

(defun scroll-down-in-place ()
  "Scroll window up without moving point (if possible)."
  (interactive)
  (scroll-in-place nil))

;; Use AltGr + f/b to go to beginning/end of next word in a Vim-like manner.
(require 'misc)
(global-set-key (kbd "đ") 'forward-to-word)
(global-set-key (kbd "”") 'backward-to-word)

;; Show git diff of current file.
(use-package git-gutter
  :config (global-git-gutter-mode +1))

;; Autocomplection framework.
(use-package company)

;; General keybindings used for company mode.
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-n") 'company-select-next))
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-p") 'company-select-previous))
(eval-after-load 'company
  '(define-key company-search-map (kbd "C-n") 'company-select-next))
(eval-after-load 'company
  '(define-key company-search-map (kbd "C-p") 'company-select-previous))
(eval-after-load 'company
  '(define-key company-search-map (kbd "C-t") 'company-search-toggle-filtering))

;; Oh boy..
(setq company-idle-delay 0.2)
(global-set-key (kbd "C-M-n") 'company-search-candidates)

;; With autocomplete comes flycheck as well.
(use-package flycheck)

;; C-Sharp mode.
(use-package omnisharp)

(add-hook 'csharp-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4)))

(eval-after-load 'company
    '(add-to-list 'company-backends 'company-omnisharp))

(defun csharp-setup()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode))
(add-hook 'csharp-mode-hook 'csharp-setup t)

;; Zoom mode becomes noticeable the size of windows gets really small.
(use-package zoom
  :config (zoom-mode 1))

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

;; Compilation key binding. Should use multi-compile in the future.
(global-set-key (kbd "C-x <C-i>") 'compile)

;; Run a python file by its compilation command.
(add-hook 'python-mode-hook
          (lambda()
            (set (make-local-variable 'compile-command)
                 (concat "python3 " buffer-file-name))))

;; Mark stuff such that they can be "dragged".
(use-package drag-stuff
  :bind (("M-2" . drag-stuff-up)
	 ("M-3" . drag-stuff-down))
  :config (drag-stuff-mode 1))

;; Shut the fuck up.
(setq ring-bell-function 'ignore)

;; Automatic haskell indentation.
(use-package hindent)
(add-hook 'haskell-mode-hook #'hindent-mode)

;; Run hindent when saving Haskell code.
(defun my-hindent-save-hook ()
  (when (eq major-mode 'haskell-mode)
    (hindent-reformat-buffer)))
(add-hook 'before-save-hook 'my-hindent-save-hook)

;; Save position in registers to use like bookmarks.
(use-package iregister
  :bind
  ("©" . iregister-point-to-register)
  ("“" . iregister-last-marker))

(defun iregister-last-marker()
  (interactive)
  (setq iregister-current-marker-register 0)
  (iregister-jump-to-previous-marker))

(global-set-key (kbd "M-,") 'iregister-last-marker)

;; bison-mode.
(use-package bison-mode)
(add-to-list 'auto-mode-alist '("\\.yy\\'" . bison-mode))

;; Default column-width of 120.
(setq-default fill-column 120)

(add-hook 'org-mode-hook
  (lambda ()
    (setq fill-column 80)))

;; General LSP stuff.
(defun my-lsp-ui-mode-hook ()
  :config
  (lsp-ui-peek-enable t)
  (setq-default lsp-ui-peek-show-directory t)
  (setq-default lsp-ui-peek-always-show t)
  (setq-default lsp-ui-peek-peek-height 40)
  (setq-default gc-cons-threshold 100000000)
  (setq-default read-process-output-max (* 2048 2048))
  (setq-default lsp-completion-provider :capf)
  (setq-default lsp-idle-delay 0.500)
  (setq-default lsp-log-io nil)
  (setq-default lsp-ui-peek-show-directory nil)
  (lsp-ui-mode))

(require 'lsp)
(use-package lsp-mode
  :bind
  (("C-t" . lsp-ui-peek-find-definitions)
   ("C-M-t" . lsp-ui-peek-find-references)))

(add-hook 'lsp-mode-hook 'my-lsp-ui-mode-hook)

(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-enable t
      lsp-ui-sideline-show-symbol nil
      lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-enable nil))

;; Edit multiple semantics matches in parallel.
(use-package iedit
  :bind
  ("C-r" . lsp-iedit-highlights))

;; Projectile for guessing root of LSP, nice with stuff like Python that you've
;; just cloned.
(setq lsp-auto-guess-root t)

;; Disable formatting with LSP. Absolute trash.
(setq lsp-enable-on-type-formatting nil)
(setq lsp-enable-indentation nil)
(setq lsp-before-save-edits nil)

;; ccls for jumping to definitions in C++.
(use-package ccls
  :config
  (setq ccls-executable "ccls")
  (setq ccls-extra-init-params '(:index (:comments 0))))

;; LSP for C-mode. Requires an actual LSP server, of course.
(add-hook 'c-mode-common-hook #'lsp)

;; https://github.com/emacs-lsp/lsp-mode/issues/466#issuecomment-438143682
(add-to-list 'xref-prompt-for-identifier 'xref-find-references t)

;; We want xrefs in a nice popwin, not replacing another buffer.
(use-package helm-xref
  :config (setq xref-show-xrefs-function 'helm-xref-show-xrefs))

;; Color matching brackets to match them.
(use-package rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Highlight indentation with a toggle.
(use-package highlight-indent-guides
  :bind (("C-|" . highlight-indent-guides-mode))
  :config
  (setq highlight-indent-guides-character ?\|)
  (setq highlight-indent-guides-method 'character))

;; Move buffers with key bindings.
(use-package buffer-move
  :bind (("<C-up>" . buf-move-up)
	 ("<C-down>" . buf-move-left)
	 ("<C-left>" . buf-move-left)
	 ("<C-right>" . buf-move-right)))

;; Inhibit startup screen.
(setq-default inhibit-startup-screen t)

;; Marks matching pairs of parentheses.
(setq-default show-paren-mode t)

;; Red trailing whitespace.
(setq-default show-trailing-whitespace t)

;; JS.
(defun js-mode-hook ()
  (setq-default js-indent-level 2)
  (setq-default indent-tabs-mode nil))

(add-hook 'js-mode 'js2-mode)
(add-hook 'js2-mode-hook 'js-mode-hook)
(add-hook 'js2-mode-hook 'add-node-modules-path)
(add-hook 'js2-mode-hook 'prettier-js-mode)

;; Python LSP.
(add-hook 'python-mode-hook 'lsp)

;; Use my own $PATH.
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Get buffer file name.
(defun describe-buffer-file-name ()
  (interactive)
  (describe-variable 'buffer-file-name))

;; Hydra.
(use-package hydra)

;; Useful for new unfamiliar code bases.
(which-function-mode)

;; When TAB does not work.
(global-set-key (kbd "§") 'indent-for-tab-command)

;; Smart tabs.
(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'c))

;; clang-format.
(use-package clang-format
  :config
  (smart-tabs-insinuate 'c))

(defun my-clang-format-save-hook ()
  (when (eq major-mode 'c++-mode)
    (clang-format-buffer)))
(add-hook 'before-save-hook 'my-clang-format-save-hook)

;; magit.
(use-package magit)

;; goto-line.
(global-set-key (kbd "C-M-p") 'goto-line)

;; truncate lines.
(setq-default truncate-lines nil)

;; centaur-tabs.
(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-set-bar 'over
		centaur-tabs-bar-set-icons t
		centaur-tabs-gray-out-icons 'buffer
		centaur-tabs-height 24
		centaur-tabs-set-modified-marker t
		centaur-tabs-modified-marker "*")
  (centaur-tabs-mode t)
  :bind
  (("C-c <C-left>" . centaur-tabs-backward)
   ("C-c <C-right>" . centaur-tabs-forward)))

(custom-set-faces
 '(centaur-tabs-unselected ((t (:background "#3D3C3D" :foreground "white" :overline nil :underline nil)))))

(global-set-key (kbd "C-c <C-down>") 'kill-current-buffer)

;; clipboard.
(setq select-enable-clipboard t)

;; gdb.
(eval-after-load 'comint
  '(progn
    (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
    (define-key comint-mode-map (kbd "C-p") 'comint-previous-input)
    (define-key comint-mode-map (kbd "<down>") 'comint-next-input)
    (define-key comint-mode-map (kbd "C-n") 'comint-previous-input)))

(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s: Can't touch this!"
     "%s is up for grabs.")
   (current-buffer)))
(global-set-key (kbd "C-c t") 'toggle-window-dedicated)

(setq-default split-width-threshold nil)
(setq-default split-height-threshold nil)

(setq-default gdb-show-main t)

;; Undo changes to windows.
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; Paste previously yanked (i.e. -2).
(global-set-key (kbd "C-M-y") '(lambda () (interactive) (yank 2)))

;; Get rid of cl warnings.
(setq byte-compile-warnings '(cl-functions))

;; Line numbers.
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; key-chord.
(use-package key-chord
  :ensure t
  :config (key-chord-mode 1))

(setq key-chord-two-keys-delay .015
      key-chord-one-key-delay .020)

;; evil-mode.
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; Replace insert mode with emacs mode.
(setq evil-insert-state-map (make-sparse-keymap))
(setq-default evil-default-state 'evil-insert-state)
(define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)

;; jk to escape back to normal mode.
(key-chord-define-global "jk" 'evil-normal-state)

;; evil keybindings.
(define-key evil-normal-state-map "t" 'avy-goto-char)
(define-key evil-normal-state-map "q" 'kill-current-buffer)
(define-key evil-normal-state-map "s" 'save-buffer)

(define-key evil-normal-state-map "h" 'evil-backward-word-begin)
(define-key evil-normal-state-map "l" 'evil-forward-word-end)

(define-key evil-normal-state-map "n" 'other-window)
(define-key evil-normal-state-map "p" 'prev-window)

(define-key evil-normal-state-map "," 'lsp-ui-peek-find-definitions)
(define-key evil-normal-state-map "." 'lsp-ui-peek-find-references)

(define-key evil-normal-state-map (kbd "C-p") 'evil-insert-state)
(define-key evil-normal-state-map (kbd "C-n") 'evil-insert-state)
(define-key evil-normal-state-map (kbd "C-@") 'evil-insert-state)

;; Mouse stuff.
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)

  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 3)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 3)))

  (defun track-mouse (e))
  (setq mouse-sel-mode t))
