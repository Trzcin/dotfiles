(defvar my/enauczanie-course-list '(
                                    ("Metody badawcze w informatyce" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=3945")
                                    ("Sieciowe systemy operacyjne" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4074")
                                    ("Zespołowy projekt badawczy" . "https://enauczanie.pg.edu.pl/2025/course/view.php?id=4323"))
    "List of enauczanie courses with the respective URLs")

(defun my/enauczanie-goto-course ()
    "Prompt for a course and open it in a web browser"
    (interactive)
    (when-let* ((course (completing-read "Wybierz kurs: " (mapcar 'car my/enauczanie-course-list) nil t))
                (url (cdr (assoc course my/enauczanie-course-list))))
                (browse-url-xdg-open url)))
