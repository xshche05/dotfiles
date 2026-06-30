
;; ============ Packages ==========

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)


;; ============ Basic =============

;; Remove tool bar
(tool-bar-mode -1)

;; Remove menu bar
(menu-bar-mode -1)

;; Remove scroll bar
(scroll-bar-mode -1)

;; Display line numbers
(global-display-line-numbers-mode 1)

;; IDO mode setupt
(ido-mode 1)
(ido-everywhere 1)

;; theme
(use-package gruber-darker-theme
  :ensure t)

;; yes or no -> y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; font
(set-face-attribute 'default nil :font "Iosevka" :height 140)

;; mouse

;; Clicking, dragging & region select in the terminal
(xterm-mouse-mode 1)

;; Make the scroll wheel scroll a few lines at a time
(unless (display-graphic-p)
  (global-set-key (kbd "<mouse-4>")
                  (lambda () (interactive) (scroll-down 5)))
  (global-set-key (kbd "<mouse-5>")
                  (lambda () (interactive) (scroll-up 5))))

;; my modules

(add-to-list 'load-path user-emacs-directory)

(require 'clipboard)
(require 'my-cleanup)

;; ========== Dired Mode ==========

(defun dired-mode-hook-setup ()
  ;; Highlight the selected line
  (hl-line-mode 1)
  (display-line-numbers-mode -1))

;; Highlight the current line in Dired
(add-hook 'dired-mode-hook 'dired-mode-hook-setup)


;; =========== Smex ===============

(use-package smex
  :ensure t
  :bind (("M-x"         . smex)
         ("M-X"         . smex-major-mode-commands)
         ("C-c M-x"     . execute-extended-command))
  :init
  (smex-initialize))


;; ======== Multi Cursor ==========

(use-package multiple-cursors
  :ensure t
  :bind (("C->"           . mc/mark-next-like-this)
         ("C-<"           . mc/mark-previous-like-this)
         ("C-c C-<"       . mc/mark-all-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click))
  :config
  (progn
    ;; You can optionally customize the face for the cursors
    (set-face-attribute 'mc/cursor-face nil :background "red" :foreground "white")
    (message "Multiple Cursors enabled.")))


;; ======== Company ===============

;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))

;; (use-package company
;;   :ensure t
;;   :config
;;   (global-company-mode 1))


;; ======== Magit =================

(use-package magit
  :ensure t)


;; ========== Eat ================

(use-package eat
  :ensure t
  :hook (eat-mode . (lambda () (display-line-numbers-mode -1))))

(defalias 'cmd 'eat)

(defun my/eat-exit-nopromt ()
  (interactive)
  (dolist (proc (process-list))
    (when (and (process-live-p proc)
               (string-match-p "\\*eat\\*" (process-name proc)))
      (message "terminating the Eat process..")
      (set-process-query-on-exit-flag proc nil))))


;; ======= Emacs exit handlers ====

(defun my/emacs-kill ()
  (interactive)
  (my/eat-exit-nopromt)
  (save-buffers-kill-terminal))

(global-set-key (kbd "C-x C-c") #'my/emacs-kill)


;; ======== LSP-MODE =============


(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init   (setq lsp-keymap-prefix "C-c l")
  :config (setq lsp-idle-delay 0.5))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config (setq lsp-ui-doc-position 'at-point
                lsp-ui-sideline-show-hover t))


(use-package lsp-ui
  :commands lsp-ui-mode
  :config (setq lsp-ui-doc-position 'at-point
                lsp-ui-sideline-show-hover t))

;; ======== Custom ================

;; Set custom file
(setq custom-file "~/.emacs.d/custom.el")

;; Load custom file
(load-file custom-file)
