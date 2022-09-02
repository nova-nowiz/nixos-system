;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


(load! "private.el") ;; This is for private information, for example name and email
;; create a private.el file with your private informations in it
;; example from default doom emacs config.el:
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;; (setq user-full-name "Full Name"
;;       user-mail-address "your@email.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack Nerd Font" :size 16))
(setq doom-variable-pitch-font (font-spec :family "DejaVu Serif" :style "Book" :size 16))
(setq doom-unicode-font (font-spec :family "Hack Nerd Font"))
(setq doom-symbol-fallback-font-families '("Hack Nerd Font"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-shades-of-purple)
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(map! :nvieomrg "C-h" #'windmove-left
      :nvieomrg "C-j" #'windmove-down
      :nvieomrg "C-k" #'windmove-up
      :nvieomrg "C-l" #'windmove-right)

(map! :mode org-mode
      :localleader "z" #'org-add-note)

(map! :after company
      :map company-active-map
      "<tab>" #'company-complete-selection
      "<return>" nil
      "C-l" #'company-complete-common)

(map! :mode magit-mode
      "%" #'magit-gitflow-popup)

(setq evil-snipe-scope 'visible)

(setq enable-local-variables 't)

(setq evil-split-window-below 't
      evil-vsplit-window-right 't)

(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "DOING(d)" "WAIT(w)" "|" "DONE(v)" "CANCELLED(x)"))
        org-todo-keyword-faces
        '(("TODO" :foreground "#2ecc71" :weight bold)
          ("DOING" :foreground "#3498db" :weight bold)
          ("WAIT" :foreground "#bdc3c7" :weight bold)
          ("DONE" :foreground "#7f8c8d" :weight bold)
          ("CANCELLED" :foreground "#e74c3c" :weight bold))
        org-priority-highest ?A
        org-priority-lowest ?G
        org-priority-default ?D
        org-priority-faces
        '((?A :foreground "#e74c3c" :weight bold)
          (?B :foreground "#e67e22" :weight bold)
          (?C :foreground "#f1c40f" :weight bold)
          (?D :foreground "#ecf0f1" :weight bold)
          (?E :foreground "#27ae60" :weight bold)
          (?F :foreground "#2ecc71" :weight bold)
          (?G :foreground "#3498db" :weight bold)))
  (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar"
        org-plantuml-exec-mode 'jar)
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted"))
        org-latex-pdf-process
        '("lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-log-into-drawer 't
        org-columns-default-format "%40ITEM(name) %TODO(status) %3PRIORITY(priority) %Effort(time estimate){:} %CLOCKSUM(time spent) %SCHEDULED(scheduled) %DEADLINE(deadline) %TIMESTAMP(timestamp) %TAGS(tags)"))

(after! ox-latex
  (add-to-list 'org-latex-classes
               '("uccthesis"
                 "\\documentclass{uccthesis}\n[NO-DEFAULT-PACKAGES]\n[NO-PACKAGES]\n[NO-EXTRA]"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;; org agenda
(after! org-agenda
 (defun org-time-to-minutes (time)
   "Convert an HHMM time to minutes"
   (+ (* (/ time 100) 60) (% time 100)))

 (defun org-time-from-minutes (minutes)
   "Convert a number of minutes to an HHMM time"
   (+ (* (/ minutes 60) 100) (% minutes 60)))

 (defadvice org-agenda-add-time-grid-maybe (around mde-org-agenda-grid-tweakify
                                                   (list ndays todayp))
   (if (member 'remove-match (car org-agenda-time-grid))
       (flet ((extract-window
               (line)
               (let ((start (get-text-property 1 'time-of-day line))
                     (dur (get-text-property 1 'duration line)))
                 (cond
                  ((and start dur)
                   (cons start
                         (org-time-from-minutes
                          (truncate
                           (+ dur (org-time-to-minutes start))))))
                  (start start)
                  (t nil)))))
         (let* ((windows (delq nil (mapcar 'extract-window list)))
                (org-agenda-time-grid
                 (list
                  (car org-agenda-time-grid)
                  (remove-if
                   (lambda (time)
                     (find-if (lambda (w)
                                (if (numberp w)
                                    (equal w time)
                                  (and (>= time (car w))
                                       (< time (cdr w)))))
                              windows))
                   (cadr org-agenda-time-grid))
                  (caddr org-agenda-time-grid)
                  (cadddr org-agenda-time-grid))))

           ad-do-it))
     ad-do-it))
 (ad-activate 'org-agenda-add-time-grid-maybe)
 (setq org-agenda-time-grid
       '((daily weekly today require-timed remove-match)
         (800 830 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300)
         "......" "----------------")
       org-agenda-start-day ""
       org-agenda-custom-commands
       '(("n" "TODOs and agenda"
          ((alltodo "" ((org-agenda-todo-ignore-scheduled 't) (org-agenda-sorting-strategy '(category-keep priority-down))))
           (agenda "" ((org-agenda-span 7))))))))

(use-package! org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list
        '("VERY HIGH" "HIGH" "MID/HIGH" "MID" "LOW" "VERY LOW" "OPTIONAL")))

;; (add-hook 'after-init-hook #'global-emojify-mode)

(after! ispell
  (setq ispell-dictionary "american,fr-toutesvariantes")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "american,fr-toutesvariantes"))

(after! langtool
  (setq langtool-default-language auto))

(global-evil-matchit-mode 1)

;; http://emacs.stackexchange.com/questions/10431/get-company-to-show-suggestions-for-yasnippet-names
;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(after! company (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))
;; (add-to-list 'company-lsp-filter-candidates '(lsp-emmy-lua . t))

(require 'server)
(unless (server-running-p)
  (server-start))
;; (global-activity-watch-mode)
(after! xenops
  (setq xenops-math-latex-process-alist
     '((dvipng
        :programs ("lualatex" "dvipng")
        :description "dvi > png"
        :message "you need to install the programs: lualatex and dvipng."
        :image-input-type "dvi"
        :image-output-type "png"
        :image-size-adjust (1.0 . 1.0)
        :latex-compiler ("lualatex -interaction nonstopmode -shell-escape -output-format dvi -output-directory %o %f")
        :image-converter ("dvipng -D %D -T tight -o %O %f"))
       (dvisvgm
        :programs ("lualatex" "dvisvgm")
        :description "dvi > svg"
        :message "you need to install the programs: lualatex and dvisvgm."
        :image-input-type "dvi"
        :image-output-type "svg"
        :image-size-adjust (1.7 . 1.5)
        :latex-compiler ("lualatex -interaction nonstopmode -shell-escape -output-format dvi -output-directory %o %f")
        :image-converter ("dvisvgm %f -n -b %B -c %S -o %O"))
       (imagemagick
        :programs ("lualatex" "convert")
        :description "pdf > png"
        :message "you need to install the programs: lualatex and imagemagick."
        :image-input-type "pdf"
        :image-output-type "png"
        :image-size-adjust (1.0 . 1.0)
        :latex-compiler ("lualatex -interaction nonstopmode -shell-escape -output-directory %o %f")
        :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O"))))
   
  (add-hook 'latex-mode-hook #'xenops-mode)
  (add-hook 'LaTeX-mode-hook #'xenops-mode)
  (add-hook 'latex-mode-hook #'xenops-xen-mode)
  (add-hook 'LaTeX-mode-hook #'xenops-xen-mode))


(after! tex
  (setq TeX-engine 'luatex))

(require 'auctex-latexmk)
(auctex-latexmk-setup)

(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse t
        lsp-ui-doc-use-webkit t
        lsp-ui-doc-max-height 40
        lsp-ui-doc-max-width 150
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-flycheck-enable t))
        

(after! typescript
  (setq lsp-clients-angular-language-server-command
        '("node" "node_modules/@angular/language-server"
              "--ngProbeLocations" "node_modules"
              "--tsProbeLocations" "node_modules"
              "--stdio")))

;; (use-package org-tanglesync
;;   :hook ((org-mode . org-tanglesync-mode)
;;          ;; enable watch-mode globally:
;;          ((prog-mode text-mode) . org-tanglesync-watch-mode))
;;   :custom
;;   (org-tanglesync-watch-files '("readme.org" "README.org"))
;;   :bind
;;   (( "C-c M-i" . org-tanglesync-process-buffer-interactive)
;;    ( "C-c M-a" . org-tanglesync-process-buffer-automatic)))

(setq sql-mysql-options [ "--protocol=tcp" "-P 3306"])
;; (add-hook 'after-init-hook #'doom/quickload-session)
;; org-ref
;; (require 'org-ref-ivy)

;; (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
;;       org-ref-insert-cite-function 'org-ref-cite-insert-ivy
;;       org-ref-insert-label-function 'org-ref-insert-label-link
;;       org-ref-insert-ref-function 'org-ref-insert-ref-link
;;       org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
(require 'org-ref)
;; remove after PR #5881
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)
(setq byte-compile-warnings '(not obsolete))
