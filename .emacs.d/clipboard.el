;;; clipboard.el --- link kill-ring with the system clipboard -*- lexical-binding: t; -*-

;; Share the kill-ring with the OS clipboard.
(setq select-enable-clipboard t              ; M-w / C-w / C-y use the clipboard
      select-enable-primary t                ; also sync the X primary selection
      save-interprogram-paste-before-kill t) ; keep external copies on the kill-ring

;; Terminal Emacs (emacs -nw) has no clipboard of its own — bridge it.
;; xclip-mode auto-detects xclip / xsel / wl-copy (Linux) or pbcopy (macOS).
(unless (display-graphic-p)
  (use-package xclip
    :ensure t
    :config (xclip-mode 1)))

(provide 'clipboard)
;;; clipboard.el ends here
