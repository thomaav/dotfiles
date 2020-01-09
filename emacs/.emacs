(define-coding-system-alias 'utf8 'utf-8)

;; TLS 1.3.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Add package repositories.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/") t)
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
(set-default-font "Consolas")
(set-face-attribute 'default nil :family "Consolas")
(set-face-attribute 'default nil :foundry "outline")
(set-face-attribute 'default nil :height 130)

;; Put custom settings in its own file.
(setq custom-file (concat user-emacs-directory "custom.el"))

;; M-n, M-p for next/previous window.
(defun prev-window ()
  (interactive)
  (other-window -1))
(define-key global-map (kbd "M-n") 'other-window)
(define-key global-map (kbd "M-p") 'prev-window)

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

;; Indentation for C/C++/GLSL.
(defvaralias 'c-basic-offset 'tab-width)
(defun c-mode-indentation ()
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil))
(add-hook 'c-mode-hook 'c-mode-indentation)
(add-hook 'c++-mode-hook 'c-mode-indentation)
(add-hook 'glsl-mode-hook 'c-mode-indentation)

;; avy-goto-char key binding. Rebind TAB properly as it does C-i by
;; default. avy-goto-char only works in GUI mode.
(define-key input-decode-map [?\C-i] [C-i])
(use-package avy
  :bind (("<C-i>" . avy-goto-char)
	 ("TAB" . #'indent-for-tab-command)))

;; Helm selection narrowing.
(use-package helm-config
  :bind (("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("M-x" . helm-M-x)
	 ("C-x M-f" . helm-find-files))
  :config (helm-mode 1))

;; Project handling.
(use-package projectile
  :config
  (projectile-mode 1)

  ;; Don't use elisp for indexing. Matters for very big projects.
  (setq projectile-indexing-method 'alien))


(use-package helm-projectile
  :bind (("C-c C-p" . helm-projectile-switch-project)
	 ("C-x C-f" . helm-projectile-find-file))
  :config (helm-projectile-on))

;; Popwin to get rid of *Help* windows etc. with a small popup window.
(use-package popwin
  :config (popwin-mode 1))

;; Display a flash of light at the cursor when scrolling.
(use-package beacon
  :config (beacon-mode 1))

;; Scroll window five lines from the bottom instead.
(use-package smooth-scrolling
  :config (smooth-scrolling-mode 1))

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
(global-set-key (kbd "M-a") 'previous-blank-line)

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

;; Org export engine.
(use-package ox-latex
  :config
  (unless (boundp 'org-latex-classes)
    (setq org-latex-classes nil)))

;; Add general LaTeX packages.
(add-to-list 'org-latex-packages-alist '("" "caption" t))

;; Add general LaTeX classes.
(add-to-list 'org-latex-classes
             '("thomaav"
               "\\documentclass[absract=on,a4paper]{scrreprt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Minted color sources in LaTeX exports.
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")))

;; ivy-mode. Mostly used for counsel-ag and swiper, using helm elsewhere.
(use-package swiper)
(use-package counsel)
(use-package ivy
  :config (ivy-mode 1))

(global-set-key (kbd "ª") 'counsel-ag)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper)

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

(global-set-key (kbd "π") 'scroll-up-in-place)
(global-set-key (kbd "“") 'scroll-down-in-place)

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
(setq company-idle-delay 0)

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
  :bind ("C-," . iregister-point-to-register))

(defun iregister-last-marker()
  (interactive)
  (setq iregister-current-marker-register 0)
  (iregister-jump-to-previous-marker))

(global-set-key (kbd "M-,") 'iregister-last-marker)

;; bison-mode.
(use-package bison-mode)
(add-to-list 'auto-mode-alist '("\\.yy\\'" . bison-mode))

;; column-width should (almost) always be 80.
(setq-default fill-column 80)

;; General LSP stuff.
(require 'lsp)
(use-package lsp-mode
  :bind (("C-t" . lsp-find-definition)
	 ("C-M-t" . lsp-find-references)))
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;; I'm unsure if I even use this stuff.
(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-enable t
      lsp-ui-sideline-show-symbol nil
      lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-enable nil))

;; Autocompletion framework with LSP.
(use-package company-lsp
  :config
  (setq company-lsp-cache-candidates nil)
  (setq lsp-enable-snippet nil))

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
  (setq ccls-executable "/home/thomaav/dev/ccls/Release/ccls")
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
  :bind (("<C-S-up>" . buf-move-up)
	 ("<C-S-down>" . buf-move-left)
	 ("<C-S-left>" . buf-move-left)
	 ("<C-S-right>" . buf-move-right)))

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

;; TeX. Semesterprosjekt.
(use-package auctex-latexmk)

(defun tex-mode-hook ()
  (auctex-latexmk-setup)
  (flyspell-mode))

(add-hook 'TeX-mode-hook 'tex-mode-hook)
(setq-default TeX-master nil)

;; Custom macro to autofill full of current paragraph.
(fset 'customfill
   [?\M-x ?i ?r ?e ?g ?i ?s ?t ?e ?r ?- ?p ?o ?i ?n ?t ?- ?t ?o ?- ?r ?e ?g ?i
   ?s ?t ?e ?r return ?\M-e ?\C- ?\M-a ?\M-q ?\M-, return])
(defun custom-fill-hook()
  (interactive)
  (execute-kbd-macro (symbol-function 'customfill)))
(global-set-key (kbd "C-M-q") 'custom-fill-hook)

;; Python LSP.
(require 'lsp-clients)
(add-hook 'python-mode-hook 'lsp)

;; Agenda and TODO stuff.
(require 'thomaav-gcal)
