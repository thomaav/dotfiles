(define-coding-system-alias 'utf8 'utf-8)

;; Package repositories.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("gnu elpa" . "https://elpa.gnu.org/packages/") t)

;; Font settings.
(set-default-font "Consolas")
(set-face-attribute 'default nil :family "Consolas")
(set-face-attribute 'default nil :foundry "outline")
(set-face-attribute 'default nil :height 130)

;; installer
(setq package-list
      '(projectile helm-projectile popwin beacon smooth-scrolling expand-region
		   multiple-cursors ivy swiper counsel flycheck gruvbox-theme
		   zoom highlight-parentheses omnisharp company drag-stuff
		   git-gutter persp-mode avy ycmd company-ycmd bison-mode
		   iregister hindent rainbow-delimiters highlight-indent-guides
		   lsp-mode lsp-ui company-lsp helm-xref ccls buffer-move))

;; Activate all the packages.
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Automatically install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

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
(load-theme 'gruvbox-dark-hard t)

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
(global-set-key (kbd "<C-i>") 'avy-goto-char)
(global-set-key (kbd "TAB") #'indent-for-tab-command)

;; Project handling.
(require 'projectile)
(projectile-mode 1)
(require 'helm-projectile)
(helm-projectile-on)

;; Helm stuff. Selection narrowing.
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)

;; Projectile stuff we use helm for.
(global-set-key (kbd "C-c C-p") 'helm-projectile-switch-project)
(global-set-key (kbd "C-x C-f") 'helm-projectile-find-file)
(global-set-key (kbd "C-x M-f") 'helm-find-files)

;; Use popwin for pop-up buffers, as it is not particularly intruding.
(require 'popwin)
(popwin-mode 1)
(setq display-buffer-function 'popwin:display-buffer)
(push '("^\*helm .+\*$" :regexp t) popwin:special-display-config)
(push '("^\*helm-.+\*$" :regexp t) popwin:special-display-config)
(setq helm-split-window-preferred-function 'ignore)

;; Display a flash of light at the cursor when scrolling.
(beacon-mode 1)

;; Scroll window five lines from the bottom instead.
(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

;; C-q will expand a region for marking, specifically regions within brackets.
(require 'expand-region)
(global-set-key (kbd "C-q") 'er/expand-region)
(put 'upcase-region 'disabled nil)

;; Emacs Rocks!
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-j") 'mc/mark-next-like-this)
(global-set-key (kbd "C-S-j") 'mc/mark-previous-like-this)

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
(global-set-key (kbd "ª") 'counsel-ag)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper)
(global-set-key (kbd "@") 'kill-whole-line)
(global-set-key (kbd "C-ø") 'subword-backward-kill)

;; Exporting LaTeX stuff.
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(add-to-list 'org-latex-classes
             '("thomaav"
               "\\documentclass[absract=on,a4paper]{scrreprt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t)))

(eval-after-load "org"
  '(progn
     ;; .txt files aren't in the list initially, but in case that changes
     ;; in a future version of org, use if to avoid errors.
     (if (assoc "\\.txt\\'" org-file-apps)
         (setcdr (assoc "\\.txt\\'" org-file-apps) "notepad.exe %s")
       (add-to-list 'org-file-apps '("\\.txt\\'" . "notepad.exe %s") t))
     ;; Change .pdf association directly within the alist.
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))

;; Minted color sources in LaTeX exports.
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")))

;; LaTeX packages.
(add-to-list 'org-latex-packages-alist '("" "caption" t))

;; We should ask for auto-filling lines in text modes.
(add-hook 'org-mode-hook
	  (lambda ()
	    (when (y-or-n-p "Auto Fill mode? ")
	      (turn-on-auto-fill))))

;; ivy-mode. I think this is mostly used for counsel/swiper.
(ivy-mode 1)

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
(global-git-gutter-mode +1)

;; C-Sharp mode.
(add-hook 'csharp-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4)))

(eval-after-load
    'company
    '(add-to-list 'company-backends 'company-omnisharp))

(defun csharp-setup()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode))

(add-hook 'csharp-mode-hook 'csharp-setup t)

;; General keybindings used for company mode.
(eval-after-load
    'company
    '(define-key company-active-map (kbd "C-n") 'company-select-next))
(eval-after-load
    'company
    '(define-key company-active-map (kbd "C-p") 'company-select-previous))
(eval-after-load
    'company
    '(define-key company-search-map (kbd "C-n") 'company-select-next))
(eval-after-load
    'company
    '(define-key company-search-map (kbd "C-p") 'company-select-previous))
(eval-after-load
    'company
    '(define-key company-search-map (kbd "C-t") 'company-search-toggle-filtering))

;; Oh boy..
(setq company-idle-delay 0)

;; Zoom mode becomes noticeable the size of windows gets really small.
(zoom-mode 1)

;; Workspaces.
(setq persp-keymap-prefix (kbd "C-x x"))
(persp-mode 1)

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
(drag-stuff-mode 1)
(global-set-key (kbd "M-2") 'drag-stuff-up)
(global-set-key (kbd "M-3") 'drag-stuff-down)

;; Shut the fuck up.
(setq ring-bell-function 'ignore)

;; Automatic haskell indentation.
(require 'hindent)
(add-hook 'haskell-mode-hook #'hindent-mode)

;; Run hindent when saving Haskell code.
(defun my-hindent-save-hook ()
  (when (eq major-mode 'haskell-mode)
    (hindent-reformat-buffer)))
(add-hook 'before-save-hook 'my-hindent-save-hook)

;; Save position in registers to use like bookmarks.
(require 'iregister)

(defun iregister-last-marker()
  (interactive)
  (setq iregister-current-marker-register 0)
  (iregister-jump-to-previous-marker))

(global-set-key (kbd "C-,") 'iregister-point-to-register)
(global-set-key (kbd "M-,") 'iregister-last-marker)

;; bison-mode.
(add-to-list 'auto-mode-alist '("\\.yy\\'" . bison-mode))

;; column-width should (almost) always be 80.
(setq-default fill-column 80)

;; LSP. Requires an actual LSP server, of course.
(require 'lsp)
(add-hook 'c-mode-common-hook #'lsp)

;; ccls for jumping to definitions in C++.
(require 'ccls)
(setq ccls-executable "/home/thomaav/dev/ccls/Release/ccls")
(setq ccls-extra-init-params '(:index (:comments 0)))

; https://github.com/emacs-lsp/lsp-mode/issues/466#issuecomment-438143682
(add-to-list 'xref-prompt-for-identifier 'xref-find-references t)

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(setq lsp-auto-guess-root t)

;; This is apparently too fancy. Disable.
(setq lsp-ui-sideline-enable t
     lsp-ui-sideline-show-symbol nil
     lsp-ui-sideline-show-hover nil)
(setq lsp-ui-doc-enable nil)

;; Only show the signature in the echo area. Not the full documentation.
(setq lsp-eldoc-render-all nil)

;; Enable completion. Let the server handle caching.
(require 'company-lsp)
(setq company-lsp-cache-candidates nil)

(setq lsp-enable-snippet nil)

;; Disable formatting. Absolute trash.
(setq lsp-enable-on-type-formatting nil)
(setq lsp-enable-indentation nil)
(setq lsp-before-save-edits nil)

;; Key bindings for go-to with lsp-mode.
(global-set-key (kbd "C-t") 'lsp-find-definition)
(global-set-key (kbd "C-M-t") 'lsp-find-references)

;; Don't use elisp for indexing. Matters for very big projects.
(setq projectile-indexing-method 'alien)

;; We want xrefs in a nice popwin, not replacing another buffer.
(require 'helm-xref)
(setq xref-show-xrefs-function 'helm-xref-show-xrefs)

;; Color matching brackets to match them.
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Highlight indentation with a toggle.
(require 'highlight-indent-guides)

(setq highlight-indent-guides-character ?\|)
(setq highlight-indent-guides-method 'character)

(global-set-key (kbd "C-|") 'highlight-indent-guides-mode)

;; Move buffers with key bindings.
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; Inhibit startup screen.
(setq-default inhibit-startup-screen t)

;; Marks matching pairs of parentheses.
(setq-default show-paren-mode t)

;; Red trailing whitspace.
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
(require 'auctex)
(require 'auctex-latexmk)

(global-set-key (kbd "C-o")  'latex-preview-pane-mode)

(defun tex-mode-hook ()
  (auctex-latexmk-setup)
  (magic-latex-buffer)
  (flyspell-mode))
(add-hook 'TeX-mode-hook 'tex-mode-hook)

