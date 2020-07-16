
(defun readproj (rproj)
  (with-temp-buffer
    (insert-file-contents rproj)
    (split-string (buffer-string) "\n" t)
    )
  )

(defun set_ess_indent_proj (rproj)
  (setq-local ess-indent-level
	      (string-to-number (nth 1 (seq-find (lambda (x) (string= (car x) "NumSpacesForTab"))
						 (mapcar #'(lambda (x) (split-string x ": ")) (readproj rproj))))))
  (message "R Project file found. Set indentation to: %s." ess-indent-level)
  )

;; search for .Rproj first in the default-directory, if it can't determine if it is an R package. Search for .Rproj in ess-r-package--find-package-path. Return nil otherwise


(defun seek_rproj (directory)
  (car (directory-files (expand-file-name directory) t "\\.[Rr]proj$"))
  ) 

(defun ess_rproj ()
  (interactive)
  (cond ((seek_rproj default-directory) (set_ess_indent_proj (seek_rproj default-directory)))
	((seek_rproj (ess-r-package--find-package-path)) (set_ess_indent_proj (seek_rproj (ess-r-package--find-package-path))))

    (t (message "R Project file not found.")))
  )

