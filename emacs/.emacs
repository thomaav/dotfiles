(define-coding-system-alias 'utf8 'utf-8)

;; add melpa for package management
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("0537901f4422f0d5f41ff43e51e39dc17d45d254fa36ce8d8d2786457759aef9" "ad54e72e0f587b7f5325bfa1de8ef8e2b3d0272d52a7ec6c553389548539f01a" "03a885ae72ea4e31e28521194e0a569e9c8fe8b7c751b6f6701b1446ee226f4d" "770181eda0f652ef9293e8db103a7e5ca629c516ca33dfa4709e2c8a0e7120f3" "20e359ef1818a838aff271a72f0f689f5551a27704bf1c9469a5c2657b417e6c" "13de1e95bbc7475e680e50333e9418becef53cb7f41ab632261efd13f9a4f57d" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (magit bison-mode avy helm-ag helm-projectile projectile glsl-mode multiple-cursors zenburn-theme smooth-scrolling popwin org nyan-mode nlinum-relative lua-mode linum-relative helm haskell-mode gruber-darker-theme go-mode expand-region cyberpunk-theme beacon anzu ac-alchemist)))
 '(show-paren-mode t)
 '(show-trailing-whitespace t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 130 :width normal)))))

;; installer
(setq package-list '(cyberpunk-theme projectile helm-projectile popwin nyan-mode nlinum-relative beacon smooth-scrolling expand-region multiple-cursors org-tree-slide ivy swiper counsel))

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
(load-theme 'cyberpunk t)

;; indentation
(defvaralias 'c-basic-offset 'tab-width)
(put 'downcase-region 'disabled nil)
;; (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))
;; (setq tab-width 4)
;; (setq indent-tabs-mode t)

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
(nyan-mode)
(nyan-start-animation)
(nyan-toggle-wavy-trail)

;; auto-complete
;; (ac-config-default)
;; (global-auto-complete-mode t)

;; linum - line numbers
(require 'linum-relative)
(global-nlinum-relative-mode t)

;; beacon (light on marker when scrolling)
(beacon-mode 1)

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)

;; expand region - must have
(require 'expand-region)
(global-set-key (kbd "C-q") 'er/expand-region)
(put 'upcase-region 'disabled nil)

;; for tomorrow
;; use altgr + f to go to _beginning_ of next word, expand on this

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-j") 'mc/mark-next-like-this)
(global-set-key (kbd "C-S-j") 'mc/mark-previous-like-this)

;; c++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq-default c-basic-offset 8
	      tab-width 8
	      indent-tabs-mode t)
;; offset for labels in class
(c-set-offset 'access-label '-)

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

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

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

;; save desktop session
(desktop-save-mode 1)

;; slideshow
(add-to-list 'load-path "~/.emacs.d/org-tree/")
(require 'org-tree-slide)

(when (require 'org-tree-slide nil t)
  (global-set-key (kbd "<f8>") 'org-tree-slide-mode)
  (global-set-key (kbd "S-<f8>") 'org-tree-slide-skip-done-toggle)
  (define-key org-tree-slide-mode-map (kbd "<f9>")
    'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<f10>")
    'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "<f11>")
    'org-tree-slide-content)
  (setq org-tree-slide-skip-outline-level 4)
  (org-tree-slide-narrowing-control-profile)
  (setq org-tree-slide-skip-done nil))


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
