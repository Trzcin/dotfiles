(defvar my/rfc-url
    "https://datatracker.ietf.org/doc/html/rfc%s"
    "The URL used to display an RFC document.
Should contain %s that will be replaced with the RFC number.")

(defun my/rfc-open ()
    "Prompt for an RFC document number and open it in the web browser."
    (interactive)
    (when-let* ((num (read-string "RFC: "))
                (url (format my/rfc-url num)))
        (browse-url-xdg-open url)))
