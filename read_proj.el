
(defun readproj ()
  (with-temp-buffer
    (insert-file-contents (car (directory-files (expand-file-name default-directory) t "\\.[Rr]proj$")))
    (split-string (buffer-string) "\n" t)
    )
  )

(defun set_ess_indent_proj ()
  (setq-local ess-indent-level
	      (string-to-number (nth 1 (seq-find (lambda (x) (string= (car x) "NumSpacesForTab"))
						 (mapcar #'(lambda (x) (split-string x ": ")) (readproj))))))
  (message "R Project file found. Set indentation to: %s." ess-indent-level)
  )

(defun ess_rproj ()
  (interactive)
  (if (directory-files (expand-file-name default-directory) t "\\.[Rr]proj$")
      (set_ess_indent_proj)
    (message "R Project file not found. Keep indentation at: %s." ess-indent-level))
  )

(define-key ess-mode-map (kbd "M-`") 'ess_read_proj)
