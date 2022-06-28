;;; reformatters.el --- -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2017 Yevgnen Koh
;;
;; Author: Yevgnen Koh <wherejoystarts@gmail.com>
;; Version: 0.0.1
;; Keywords:
;; Package-Requires: ((emacs "24.3") (reformatter "0"))
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;;
;;
;; See documentation on https://github.com/Yevgnen/reformatters.el.

;;; Code:

(require 'subr-x)
(require 'reformatter)

;;;###autoload (autoload 'black-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'black-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'black-format-on-save-mode "reformatters.el" nil t)
(reformatter-define black-format
  :program "blackd-client")

;;;###autoload (autoload 'isort-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'isort-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'isort-format-on-save-mode "reformatters.el" nil t)
(reformatter-define isort-format
  :program "isort"
  :args `("--float-to-top" "-"))

;;;###autoload (autoload 'autoflake-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'autoflake-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'autoflake-format-on-save-mode "reformatters.el" nil t)
(reformatter-define autoflake-format
  :program "autoflake"
  :args '("--remove-all-unused-imports" "-i" "-"))

;;;###autoload (autoload 'json-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'json-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'json-format-on-save-mode "reformatters.el" nil t)
(reformatter-define json-format
  :program "jq"
  :args '("--indent" "4" "."))

;;;###autoload (autoload 'rustfmt-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'rustfmt-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'rustfmt-format-on-save-mode "reformatters.el" nil t)
(reformatter-define rustfmt-format
  :program "rustfmt")

;;;###autoload (autoload 'html-beautify-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'html-beautify-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'html-beautify-format-on-save-mode "reformatters.el" nil t)
(reformatter-define html-beautify-format
  :program "html-beautify")

;;;###autoload (autoload 'css-beautify-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'css-beautify-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'css-beautify-format-on-save-mode "reformatters.el" nil t)
(reformatter-define css-beautify-format
  :program "css-beautify")

;;;###autoload (autoload 'js-beautify-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'js-beautify-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'js-beautify-format-on-save-mode "reformatters.el" nil t)
(reformatter-define js-beautify-format
  :program "js-beautify")

;;;###autoload (autoload 'shfmt-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'shfmt-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'shfmt-format-on-save-mode "reformatters.el" nil t)
(reformatter-define shfmt-format
  :program "shfmt"
  :args '("-i" "4"))

;;;###autoload (autoload 'prettier-yaml-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'prettier-yaml-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'prettier-yaml-format-on-save-mode "reformatters.el" nil t)
(reformatter-define prettier-yaml-format
  :program "prettier"
  :args '("--parser" "yaml"))

;;;###autoload (autoload 'prettier-toml-format-buffer "reformatters.el" nil t)
;;;###autoload (autoload 'prettier-toml-format-region "reformatters.el" nil t)
;;;###autoload (autoload 'prettier-toml-format-on-save-mode "reformatters.el" nil t)
(reformatter-define prettier-toml-format
  :program "prettier"
  :args '("--parser" "toml"))

(defcustom reformatters-formtters
  '((rust-mode . rustfmt-format)
    (python-mode . (autoflake-format isort-format black-format))
    (web-mode . html-beautify-format)
    (html-mode . html-beautify-format)
    (js-mode . js-beautify-format)
    (css-mode . css-beautify-format)
    (json-mode . json-format)
    (sh-mode . shfmt-format))
  "Formatter alist.")

;;;###autoload
(defun reformatters-format-buffer ()
  (interactive)
  (if-let* ((formatters (cdar (cl-remove-if-not #'(lambda (x)
                                                    (derived-mode-p (car x)))
                                                reformatters-formtters))))
      (progn
        (unless (listp formatters)
          (setq formatters (list formatters)))
        (dolist (formater formatters)
          (call-interactively formater)))
    (user-error "No formatter associated with %s." major-mode)))

(provide 'reformatters)

;;; reformatters.el ends here
