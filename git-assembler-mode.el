;;; git-assembler-mode.el --- git-assembler major mode  -*- lexical-binding: t -*-

;; Author: Yuri D'Elia <wavexx@thregr.org>
;; Version: 0.1
;; URL: https://gitlab.com/wavexx/git-assembler-mode.el
;; Package-Requires: ((emacs "24.4"))
;; Keywords: git, git-assembler, languages, highlight, syntax

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;; Commentary:

;; `git-assembler-mode' is a major mode to edit git-assembler[0]
;; configuration files. It currently provides font-lock support.
;;
;; Once installed, ``.git/assembly`` and ``.gitassembly`` files
;; automatically open in this mode.
;;
;; [0] https://www.thregr.org/~wavexx/software/git-assembler/

;;; Code:

;;;###autoload
(add-to-list
 'auto-mode-alist
 '("\\(\\.gitassembly\\|\\.git/assembly\\)\\'" . git-assembler-mode))


;; Customizable faces
(defgroup git-assembler-faces nil
  "Faces used in git-assembler-mode"
  :group 'faces)

(defface git-assembler-command-face
  '((t :inherit font-lock-keyword-face))
  "Face used for commands."
  :group 'git-assembler-faces)

(defface git-assembler-target-face
  '((t :inherit font-lock-variable-name-face))
  "Face used for target branches."
  :group 'git-assembler-faces)

(defface git-assembler-branch-face
  '((t :inherit default))
  "Face used for generic branches."
  :group 'git-assembler-faces)

(defface git-assembler-base-face
  '((t :inherit font-lock-type-face))
  "Face used for base branches."
  :group 'git-assembler-faces)

(defface git-assembler-origin-face
  '((t :weight bold))
  "Face attributes used for highlighting a branch origin."
  :group 'git-assembler-faces)

(defface git-assembler-flags-face
  '((t :inherit font-lock-constant-face))
  "Face used for git flags."
  :group 'git-assembler-faces)



;; Mode

;;;###autoload
(define-derived-mode git-assembler-mode fundamental-mode "Git-assembler"
  "Major mode for git-assembler configuration files."

  ;; comments
  (setq-local comment-start "#"
              comment-end "")

  ;; extra branch chars
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?* "w")

  (font-lock-add-keywords
   nil
   '(;; comments
     ("#.*" . 'font-lock-comment-face)

     ;; commands with TARGET BRANCH* -FLAGS* syntax
     ("^\\s-*\\(merge\\)\\s-+\\(\\(\\(?:\\sw+/\\)+\\)?\\S-+\\)"
      (1 'git-assembler-command-face)
      (2 'git-assembler-target-face)
      (3 'git-assembler-origin-face prepend t)
      ;; branches
      ("\\=\\s-+\\(\\(\\(?:[^-\\Sw]\\sw*/\\)+\\)?[^-\\s-]\\S-*\\)" nil nil
       (1 'git-assembler-branch-face)
       (2 'git-assembler-origin-face prepend t))
      ;; flags
      ("\\=\\s-+\\(-[^#]*\\)" nil nil
       (1 'git-assembler-flags-face)))

     ;; commands with TARGET BASE syntax
     ("^\\s-*\\(base\\|stage\\)\\s-+\\(\\S-+\\)\\s-+\\(\\(\\(?:\\sw+/\\)+\\)?\\S-+\\)"
      (1 'git-assembler-command-face)
      (2 'git-assembler-target-face)
      (3 'git-assembler-base-face)
      (4 'git-assembler-origin-face prepend t))

     ;; commands with TARGET BASE -FLAGS* syntax
     ("^\\s-*\\(rebase\\)\\s-+\\(\\S-+\\)\\s-+\\(\\(\\(?:\\sw+/\\)+\\)?\\S-+\\)"
      (1 'git-assembler-command-face)
      (2 'git-assembler-target-face)
      (3 'git-assembler-base-face)
      (4 'git-assembler-origin-face prepend t)
      ;; flags
      ("\\=\\s-+\\(-[^#]*\\)" nil nil
       (1 'git-assembler-flags-face)))

     ;; commands with BRANCH* syntax
     ("^\\s-*\\(target\\)"
      (1 'git-assembler-command-face)
      ;; branches
      ("\\=\\s-+\\(\\(\\(?:\\sw+/\\)+\\)?\\S-+\\)" nil nil
       (1 'git-assembler-target-face)
       (2 'git-assembler-origin-face prepend t)))

     ;; flags
     ("^\\s-*\\(flags\\)\\s-+\\(merge\\|rebase\\)\\>"
      (1 'git-assembler-command-face)
      (2 'git-assembler-command-face)
      ;; flags
      ("\\=\\s-+\\(-[^#]*\\)" nil nil
       (1 'git-assembler-flags-face prepend))))))

(provide 'git-assembler-mode)

;;; git-assembler-mode.el ends here
