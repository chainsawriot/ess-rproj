
(defun readproj (rproj)
  (with-temp-buffer
    (insert-file-contents rproj)
    (split-string (buffer-string) "\n" t)
    )
  )

(defun set_ess_indent_proj (rproj)
  (if (null rproj)
      (message "R Project file not found.")
    (progn
      (setq-local ess-indent-level
		  (string-to-number (nth 1 (seq-find (lambda (x) (string= (car x) "NumSpacesForTab"))
						     (mapcar #'(lambda (x) (split-string x ": ")) (readproj rproj))))))
  (message "R Project file found. Set indentation to: %s." ess-indent-level)
      )
    )
  )

;; search for .Rproj first in the default-directory, if it can't determine if it is an R package. Search for .Rproj in ess-r-package--find-package-path. Return nil otherwise


(defun seek_rproj (directory)
  (car (directory-files (expand-file-name directory) t "\\.[Rr]proj$"))
  ) 


(defun getrproj ()
  "if default directory is an R package, return full path to the root directory; otherwise, return full path of default directory"
  (setq-local root (plist-get (ess-r-package-info default-directory) :root))
    (cond ((null root) (seek_rproj (expand-file-name default-directory)))
	  ((stringp root) (seek_rproj (expand-file-name root)))
    ))


(defun ess_rproj ()
  (interactive)
  (setq-local x (getrproj))
  (set_ess_indent_proj x))

