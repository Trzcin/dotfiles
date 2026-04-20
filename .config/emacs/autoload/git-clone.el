(defvar my/git-clone-list-repo-urls-cmd
    "gh repo list -L 100 --json sshUrl -q '.[] | .sshUrl'"
    "Command to list git ssh clone urls of user owned repositories.")

(defvar my/git-clone-base-dir
    "~/projects/"
    "Directory that should hold cloned repositories.")

(defun my/git-clone ()
    "Git clone"
    (interactive)
    (when-let* ((copied (evil-get-register ?+ t))
                (clone-urls (s-split "\n" (shell-command-to-string my/git-clone-list-repo-urls-cmd) t))
                (clone-urls (if (and copied
                                     (or (string-match-p "^\\(?:http\\|https\\|ssh\\|git\\)://" copied)
                                         (string-match-p "^git@" copied)))
                                (cons copied clone-urls)
                                clone-urls))
                (clone-url (let ((vertico-sort-function nil)) (completing-read "Clone URL: " clone-urls)))
                (clone-dir (f-join my/git-clone-base-dir (file-name-base clone-url)))
                (clone-cmd (format "git clone %s %s" clone-url clone-dir)))
        (shell-command clone-cmd)
        (dired clone-dir)))
