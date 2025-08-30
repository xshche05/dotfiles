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

;; ========== Dired Mode ==========

(defun dired-mode-hook-setup ()
  ;; Highlight the selected line
  (hl-line-mode 1))

;; Highlight the current line in Dired
(add-hook 'dired-mode-hook 'dired-mode-hook-setup)


;; ========== Clean Up ============

(load "~/.emacs.d/my-cleanup.el")

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

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package company
  :ensure t
  :config
  (global-company-mode 1))

;; ======== Custom ================

;; Set custom file
(setq custom-file "~/.emacs.d/custom.el")

;; Load custom file
(load-file custom-file)
