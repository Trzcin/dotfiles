(defvar my/journal-dir
    "~/Documents/org-notes/Journal"
    "The directory in which journal entries will be stored.")

(defun my/journal-create-or-edit-todays-entry ()
    "Switches to todays journal file if it exists or creates one if needed."
    (interactive)
    (let*
        ((journal-file (f-join my/journal-dir (format-time-string "%Y-%m-%d-dziennik.org.gpg"))))
        (find-file journal-file)
        (when (not (file-exists-p journal-file))
            (insert "#+title: Dziennik\n")
            (insert "#+date: ")
            (org-insert-timestamp (current-time) t)
            (newline 2))))
