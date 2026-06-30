;;; my-cleanup.el --- Per-file whitespace display & auto-format on save -*- lexical-binding: t; -*-

;;; ---------------------------------------------------------------------------
;;; Persistent per-file lists
;;; ---------------------------------------------------------------------------

(defcustom my/whitespace-disabled-files '()
  "Absolute file paths where `whitespace-mode' should NOT be shown.
`whitespace-mode' is enabled everywhere by default; add files here to
opt them out.  Manage with `my/whitespace-disable' /
`my/whitespace-enable', or edit via \\[customize-variable]."
  :type '(repeat string)
  :group 'files)

(defcustom my/autoindent-enabled-files '()
  "Absolute file paths that are auto-formatted (indented) on save.
Auto-indent is OFF by default; add files here to opt them in.
Manage with `my/autoindent-enable' / `my/autoindent-disable'."
  :type '(repeat string)
  :group 'files)

;;; ---------------------------------------------------------------------------
;;; Helper
;;; ---------------------------------------------------------------------------

(defun my/--current-file ()
  "Absolute path of the file in the current buffer, or nil."
  (when buffer-file-name (expand-file-name buffer-file-name)))

;;; ---------------------------------------------------------------------------
;;; whitespace-mode : ON everywhere, opt-out per file
;;; ---------------------------------------------------------------------------

(defun my/whitespace-disable ()
  "Turn `whitespace-mode' OFF for the current file, persistently."
  (interactive)
  (if-let ((path (my/--current-file)))
      (progn
        (add-to-list 'my/whitespace-disabled-files path)
        (customize-save-variable 'my/whitespace-disabled-files
                                 my/whitespace-disabled-files)
        (whitespace-mode -1)
        (message "whitespace-mode DISABLED for: %s" path))
    (message "Buffer is not visiting a file.")))

(defun my/whitespace-enable ()
  "Turn `whitespace-mode' back ON for the current file, persistently."
  (interactive)
  (if-let ((path (my/--current-file)))
      (progn
        (setq my/whitespace-disabled-files
              (delete path my/whitespace-disabled-files))
        (customize-save-variable 'my/whitespace-disabled-files
                                 my/whitespace-disabled-files)
        (whitespace-mode 1)
        (message "whitespace-mode ENABLED for: %s" path))
    (message "Buffer is not visiting a file.")))

(defun my/whitespace-maybe-enable ()
  "Enable `whitespace-mode' unless the current file is opted out."
  (when-let ((path (my/--current-file)))
    (if (member path my/whitespace-disabled-files)
        (whitespace-mode -1)
      (whitespace-mode 1))))

(add-hook 'prog-mode-hook #'my/whitespace-maybe-enable)
(add-hook 'text-mode-hook #'my/whitespace-maybe-enable)

;;; ---------------------------------------------------------------------------
;;; Auto-indent / format on save : OFF by default, opt-in per file
;;; ---------------------------------------------------------------------------

(defun my/autoindent-enable ()
  "Enable auto-format-on-save for the current file, persistently."
  (interactive)
  (if-let ((path (my/--current-file)))
      (progn
        (add-to-list 'my/autoindent-enabled-files path)
        (customize-save-variable 'my/autoindent-enabled-files
                                 my/autoindent-enabled-files)
        (message "Auto-indent ENABLED for: %s" path))
    (message "Buffer is not visiting a file.")))

(defun my/autoindent-disable ()
  "Disable auto-format-on-save for the current file, persistently."
  (interactive)
  (if-let ((path (my/--current-file)))
      (progn
        (setq my/autoindent-enabled-files
              (delete path my/autoindent-enabled-files))
        (customize-save-variable 'my/autoindent-enabled-files
                                 my/autoindent-enabled-files)
        (message "Auto-indent DISABLED for: %s" path))
    (message "Buffer is not visiting a file.")))

(defun my/autoindent-on-save ()
  "Re-indent and tidy the buffer before saving, when opted in."
  (when (and (my/--current-file)
             (member (my/--current-file) my/autoindent-enabled-files))
    (save-excursion
      (message "Auto-formatting buffer...")
      (untabify (point-min) (point-max))        ; tabs -> spaces
      (indent-region (point-min) (point-max))   ; re-indent everything
      (delete-trailing-whitespace)
      (goto-char (point-max))
      (delete-blank-lines)
      (unless (bolp) (insert "\n"))             ; ensure single final newline
      (message "Auto-formatting buffer... done."))))

(add-hook 'before-save-hook #'my/autoindent-on-save)

(provide 'my-cleanup)
;;; my-cleanup.el ends here
