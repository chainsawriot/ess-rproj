
(defun read-proj (rproj)
  (with-temp-buffer
    (insert-file-contents rproj)
    (split-string (buffer-string) "\n" t)
    )
  )

(defun set-ess-indent-proj (rproj)
  (if (null rproj)
      (message "R Project file not found.")
    (progn
      (setq-local ess-indent-level
		  (string-to-number (nth 1 (seq-find (lambda (x) (string= (car x) "NumSpacesForTab"))
						     (mapcar #'(lambda (x) (split-string x ": ")) (read-proj rproj))))))
  (message "R Project file found. Set indentation to: %s." ess-indent-level)
      )
    )
  )


(defun seek-rproj (directory)
  (car (directory-files (expand-file-name directory) t "\\.[Rr]proj$"))
  ) 


(defun get-rproj ()
  "if default directory is an R package, return full path to the root directory; otherwise, return full path of default directory"
  (setq-local root (plist-get (ess-r-package-info default-directory) :root))
    (cond ((null root) (seek-rproj (expand-file-name default-directory)))
	  ((stringp root) (seek-rproj (expand-file-name root)))
    ))


(defun ess-rproj ()
  (interactive)
  (set-ess-indent-proj (get-rproj))
  )

