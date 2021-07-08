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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-challenger-deep)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


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

(map! "C-h" #'windmove-left
      "C-j" #'windmove-down
      "C-k" #'windmove-up
      "C-l" #'windmove-right)

(map! :map vterm-mode-map
      "C-h" #'windmove-left
      "C-j" #'windmove-down
      "C-k" #'windmove-up
      "C-l" #'windmove-right)

(map! :map treemacs-mode-map
      "C-h" #'windmove-left
      "C-j" #'windmove-down
      "C-k" #'windmove-up
      "C-l" #'windmove-right)

(map! :after company
      :map company-active-map
      "<tab>" #'company-complete-selection
      "<return>" nil
      "C-l" #'company-complete-common)

(map! :map magit-mode-map
      "%" #'magit-gitflow-popup)

(setq enable-local-variables 't)

(after! org
  (map! :map org-mode-map)
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
  (setq org-plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")
  (setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "lualatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

;; (use-package org-fancy-priorities
;;   :hook (org-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-fancy-priorities-list '("VERY HIGH" "HIGH" "MID/HIGH" "MID" "LOW" "VERY LOW" "OPTIONAL")))

;; (add-hook 'after-init-hook #'global-emojify-mode)

(after! ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,fr_FR")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US"))

(after! langtool
  (setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*")
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#12111E" "#FF8080" "#95FFA4" "#FFE9AA" "#91DDFF" "#C991E1" "#AAFFE4" "#CBE3E7"])
 '(custom-safe-themes
   (quote
    ("3577ee091e1d318c49889574a31175970472f6f182a9789f1a3e9e4513641d86" default)))
 '(fci-rule-color "#858FA5")
 '(jdee-db-active-breakpoint-face-colors (cons "#100E23" "#906CFF"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#100E23" "#95FFA4"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#100E23" "#565575"))
 '(objed-cursor-color "#FF8080")
 '(pdf-view-midnight-colors (cons "#CBE3E7" "#1E1C31"))
 '(rustic-ansi-faces
   ["#1E1C31" "#FF8080" "#95FFA4" "#FFE9AA" "#91DDFF" "#C991E1" "#AAFFE4" "#CBE3E7"])
 '(vc-annotate-background "#1E1C31")
 '(vc-annotate-color-map
   (list
    (cons 20 "#95FFA4")
    (cons 40 "#b8f7a6")
    (cons 60 "#dbf0a8")
    (cons 80 "#FFE9AA")
    (cons 100 "#ffd799")
    (cons 120 "#ffc488")
    (cons 140 "#FFB378")
    (cons 160 "#eda79b")
    (cons 180 "#db9cbd")
    (cons 200 "#C991E1")
    (cons 220 "#db8bc0")
    (cons 240 "#ed85a0")
    (cons 260 "#FF8080")
    (cons 280 "#d4757d")
    (cons 300 "#aa6a7a")
    (cons 320 "#805f77")
    (cons 340 "#858FA5")
    (cons 360 "#858FA5")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
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
        :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O")))
   )
  (add-hook 'latex-mode-hook #'xenops-mode)
  (add-hook 'LaTeX-mode-hook #'xenops-mode)
  (add-hook 'latex-mode-hook #'xenops-xen-mode)
  (add-hook 'LaTeX-mode-hook #'xenops-xen-mode)
)

(after! tex
  (setq TeX-engine 'luatex))

(require 'auctex-latexmk)
(auctex-latexmk-setup)
(after! lsp-ui
  (setq lsp-ui-doc-max-height 40
        lsp-ui-doc-max-width 150
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-use-webkit nil
        lsp-ui-flycheck-enable t
        )
  (setq-default
        lsp-ui-doc-frame-parameters
        '((left . -1)
          (top . -1)
          (min-width  . 0)
          (min-height  . 0)
          (width  . 0)
          (height  . 0)
          (no-focus-on-map . t)
          (internal-border-width . nil)
          (vertical-scroll-bars . nil)
          (horizontal-scroll-bars . nil)
          (right-fringe . 0)
          (left-fringe . 0)
          (menu-bar-lines . 0)
          (tool-bar-lines . 0)
          (line-spacing . 0)
          (unsplittable . t)
          (undecorated . t)
          (visibility . nil)
          (mouse-wheel-frame . nil)
          (no-other-frame . t)
          (inhibit-double-buffering . t)
          (drag-internal-border . t)
          (drag-with-header-line . t)
          (no-special-glyphs . t)
          (desktop-dont-save . t))
        )
  (lsp-ui-doc-mode)
  (defun lsp-ui-doc--extract-marked-string (marked-string &optional language)
    (string-trim-right
     (let* ((string (if (stringp marked-string)
                        marked-string
                      (lsp:markup-content-value marked-string)))
            (with-lang (lsp-marked-string? marked-string))
            (language (or (and with-lang
                               (or (lsp:marked-string-language marked-string)
                                   (lsp:markup-content-kind marked-string)))
                          language))
            (markdown-hr-display-char nil))
       (cond
        (lsp-ui-doc-use-webkit
         (if (and language (not (or (string= "text" language)
                                    (string= "markdown" language))))
             (format "```%s\n%s\n```" language string)
           string))
        (t (lsp--render-element (lsp-ui-doc--inline-formatted-string string))))))))

(after! typescript
  (setq lsp-clients-angular-language-server-command
        '("node" "node_modules/@angular/language-server"
              "--ngProbeLocations" "node_modules"
              "--tsProbeLocations" "node_modules"
              "--stdio")))

(setq scroll-conservatively 0)
;; (add-hook 'after-init-hook #'doom/quickload-session)
