(define-coding-system-alias 'utf8 'utf-8)

;; add melpa for package management
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/")
 t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (scala-mode magit bison-mode avy helm-ag helm-projectile projectile
                glsl-mode multiple-cursors zenburn-theme smooth-scrolling
                popwin org nyan-mode nlinum-relative lua-mode linum-relative
                helm haskell-mode gruber-darker-theme go-mode expand-region
                cyberpunk-theme beacon anzu ac-alchemist git-gutter gruvbox-theme
		zoom)))
 '(show-paren-mode t)
 '(show-trailing-whitespace t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 130 :width normal)))))
(set-default-font "Consolas")

;; installer
(setq package-list
      '(cyberpunk-theme projectile helm-projectile popwin
                        nyan-mode nlinum-relative beacon smooth-scrolling
                        expand-region multiple-cursors org-tree-slide ivy
                        swiper counsel flycheck gruvbox-theme))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; M-n, M-p for next/previous window
(defun prev-window ()
  (interactive)
  (other-window -1))
(define-key global-map (kbd "M-n") 'other-window)
(define-key global-map (kbd "M-p") 'prev-window)

;; electric pair mode, {} both at once
(electric-pair-mode 1)

;; dont scroll out of the window horizontally
(put 'scroll-left 'disabled nil)

;; remove tool bar at the top
(tool-bar-mode -1)

;; remove menu-bar
(menu-bar-mode -1)

;; remove scroll bar
(scroll-bar-mode -1)

;; backup to somewhere else, and not cwd with *~
(setq backup-directory-alist '(("." . "~/Emacs_Backup")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/Emacs_Backup" t)))

;; camelcase mode whenever
(add-hook 'prog-mode-hook 'subword-mode)

;; keybind commenting/uncommenting region
(global-set-key (kbd "M-c") 'comment-region)
(global-set-key (kbd "C-x M-c") 'uncomment-region)

;; change keybindings for position registers
;; C-, for make marker, M-x to go back to marker (simple)
(global-set-key (kbd "C-,") (kbd "C-x r SPC r"))
(global-set-key (kbd "M-,") (kbd "C-x r j r"))

;; load pyberpunk theme
(load-theme 'gruvbox-dark-hard t)

;; c++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; offset for labels in class
(c-set-offset 'access-label '-)

;; indentation for C, c++, glsl
(defvaralias 'c-basic-offset 'tab-width)
(defun c-mode-indentation ()
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil))
(add-hook 'c-mode-hook 'c-mode-indentation)
(add-hook 'c++-mode-hook 'c-mode-indentation)
(add-hook 'glsl-mode-hook 'c-mode-indentation)

;; bind avy-goto-char
(define-key input-decode-map [?\C-i] [C-i]) ;; only works in gui mode
(global-set-key (kbd "<C-i>") 'avy-goto-char)
(global-set-key (kbd "TAB") #'indent-for-tab-command)

;; projectile
(require 'projectile)
(projectile-mode 1)
(require 'helm-projectile)
(helm-projectile-on)

;; helm
(require 'helm-config)
(helm-mode 1)
;; (helm-autoresize-mode t) don't resize for now
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c C-p") 'helm-projectile-switch-project)
(global-set-key (kbd "C-x C-f") 'helm-projectile-find-file)
(global-set-key (kbd "C-x M-f") 'helm-find-files)

;; popwin
(require 'popwin)
(popwin-mode 1)
(setq display-buffer-function 'popwin:display-buffer)
(push '("^\*helm .+\*$" :regexp t) popwin:special-display-config)
(push '("^\*helm-.+\*$" :regexp t) popwin:special-display-config)
(setq helm-split-window-preferred-function 'ignore)

;; nyan cat
;; (nyan-mode nil)
;; (nyan-start-animation)
;; (nyan-toggle-wavy-trail)

;; beacon (light on marker when scrolling)
(beacon-mode 1)

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

;; expand region - must have
(require 'expand-region)
(global-set-key (kbd "C-q") 'er/expand-region)
(put 'upcase-region 'disabled nil)

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-j") 'mc/mark-next-like-this)
(global-set-key (kbd "C-S-j") 'mc/mark-previous-like-this)

;; whitespace functions
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

;; fast forward rewind cursor
(global-set-key (kbd "M-e") 'next-blank-line)
(global-set-key (kbd "M-a") 'previous-blank-line)

;; rebinding
(global-set-key (kbd "ø") (kbd "{"))
(global-set-key (kbd "æ") (kbd "}"))
(global-set-key (kbd "Ø") (kbd "("))
(global-set-key (kbd "Æ") (kbd ")"))
(global-set-key (kbd "€") (kbd "["))
(global-set-key (kbd "®") (kbd "]"))
(global-set-key (kbd "å") (kbd "/"))
(global-set-key (kbd "C-|") (kbd "λ"))
(global-set-key (kbd "ð") 'undo)
(global-set-key (kbd "ª") 'counsel-ag)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper)
(global-set-key (kbd "@") 'kill-whole-line)
(global-set-key (kbd "C-ø") 'subword-backward-kill)

;; Exporting latex / pdflatex
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
     ;; in a future version of org, use if to avoid errors
     (if (assoc "\\.txt\\'" org-file-apps)
         (setcdr (assoc "\\.txt\\'" org-file-apps) "notepad.exe %s")
       (add-to-list 'org-file-apps '("\\.txt\\'" . "notepad.exe %s") t))
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "evince %s")))

;; minted color source
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")))

;; ask to auto fill lines on text files
(add-hook 'org-mode-hook
	  (lambda ()
	    (when (y-or-n-p "Auto Fill mode? ")
	      (turn-on-auto-fill))))

;; ivy
(ivy-mode 1)

;; scroll in place
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

;;;; ------------------------------------------------------------------------
(defun scroll-up-in-place ()
  "Scroll window up without moving point (if possible)."
  (interactive)
  (scroll-in-place t))

;;;; ------------------------------------------------------------------------
(defun scroll-down-in-place ()
  "Scroll window up without moving point (if possible)."
  (interactive)
  (scroll-in-place nil))

(global-set-key (kbd "π") 'scroll-up-in-place)
(global-set-key (kbd "“") 'scroll-down-in-place)

;; use altgr + f to go to _beginning_ of next word
(require 'misc)
(global-set-key (kbd "đ") 'forward-to-word)
(global-set-key (kbd "”") 'backward-to-word)

;; git-gutter
(global-git-gutter-mode +1)

;; C-Sharp mode
(add-hook 'csharp-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2)))

;; zoom
(zoom-mode 1)

;; persp-mode
(persp-mode 1)
