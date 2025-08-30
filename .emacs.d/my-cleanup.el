;; My cleanup functions 

;; --- The Persistent Variable ---

(defcustom my/cleanup-enabled-files '()
  "A list of absolute file paths that should be auto-formatted on save.
You can manage this list with the functions
'my/cleanup-enable-for-current-file' and
'my/cleanup-disable-for-current-file', or edit it directly
via 'M-x customize-variable'."
  :type '(repeat string)
  :group 'files)

;; --- Commands to Manage the List ---

(defun my/cleanup-buffer-enable ()
  "Add the current file to the auto-cleanup list, making it persistent."
  (interactive)
  (if-let ((filename (buffer-file-name)))
      (let ((abs-path (expand-file-name filename)))
        (add-to-list 'my/cleanup-enabled-files abs-path)
        (customize-save-variable 'my/cleanup-enabled-files my/cleanup-enabled-files)
        (message "Auto-cleanup ENABLED for: %s" abs-path))
    (message "Buffer is not visiting a file.")))

(defun my/cleanup-buffer-disable ()
  "Remove the current file from the auto-cleanup list."
  (interactive)
  (if-let ((filename (buffer-file-name)))
      (let ((abs-path (expand-file-name filename)))
        (setq my/cleanup-enabled-files (delete abs-path my/cleanup-enabled-files))
        (customize-save-variable 'my/cleanup-enabled-files my/cleanup-enabled-files)
        (message "Auto-cleanup DISABLED for: %s" abs-path))
    (message "Buffer is not visiting a file.")))

;; --- Hook Function ---

(defun my/cleanup-buffer-on-save ()
  "Clean up and format the buffer before saving.
This function only runs if the current file's path is in the
'my/cleanup-enabled-files' list."
  ;; Check if the current file is in our persistent list.
  (when (and buffer-file-name (member (expand-file-name buffer-file-name) my/cleanup-enabled-files))

    ;; save-excursion keeps the cursor from jumping around.
    (save-excursion
      (message "Auto-formatting buffer...")
      (whitespace-mode -1)
      ;; 1. Replace tabs with spaces.
      (untabify (point-min) (point-max))

      ;; 2. Re-indent the entire file.
      (indent-region (point-min) (point-max))

      ;; 3. Remove trailing whitespace.
      (delete-trailing-whitespace)

      ;; 4. Go to the end, delete blank lines, and ensure a single newline.
      (goto-char (point-max))
      (delete-blank-lines)
      (unless (bolp)
        (insert "\n"))

      (message "Auto-formatting buffer... done."))))

;; Add the updated function to the hook (this line remains the same).
(add-hook 'before-save-hook #'my/cleanup-buffer-on-save)

;; --- Conditionally enable whitespace-mode ---

(defun my/whitespace-for-non-cleanup-files ()
  "Enable 'whitespace-mode' for files that are NOT in the auto-cleanup list.
This provides visual feedback on whitespace for files that are not
being automatically formatted."
  ;; First, ensure we are in a buffer that is visiting a file.
  (when (buffer-file-name)
    (let ((abs-path (expand-file-name buffer-file-name)))
      ;; The core logic: Run this code ONLY IF the current file
      ;; is NOT a member of our persistent cleanup list.
      (unless (member abs-path my/cleanup-enabled-files)
        (whitespace-mode 1)))))

(add-hook 'prog-mode-hook #'my/whitespace-for-non-cleanup-files)
(add-hook 'text-mode-hook #'my/whitespace-for-non-cleanup-files)
