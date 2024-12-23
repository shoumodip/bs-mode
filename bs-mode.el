;;; bs-mode.el --- Major mode for editing BS source code -*- lexical-binding: t; -*-

;; Copyright 2024 Shoumodip Kar <shoumodipkar@gmail.com>
;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of
;; this software and associated documentation files (the "Software"), to deal in
;; the Software without restriction, including without limitation the rights to
;; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is furnished to do
;; so, subject to the following conditions:
;;
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:
;;
;; Major mode for editing BS source code.

(require 'ansi-color)

(defconst bs-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
	(modify-syntax-entry ?' "\"")

    (modify-syntax-entry ?/ ". 124b")
    (modify-syntax-entry ?* ". 23n")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?\^m "> b")

    (syntax-table))
  "Syntax table for `bs-mode'.")

(eval-and-compile
  (defconst bs-keywords
    '("len" "panic" "assert" "import" "typeof" "delete" "if" "then" "else"
      "match" "in" "is" "for" "while" "break" "continue" "pub" "fn" "var"
      "return" "class")))

(eval-and-compile
  (defconst bs-constants
    '("nil" "true" "false" "this" "super" "is_main_module")))

(defconst bs-font-lock-defaults
  `(("\\`#!/.*" 0 font-lock-preprocessor-face t)
    (,(regexp-opt bs-keywords 'symbols) . font-lock-keyword-face)
    (,(regexp-opt bs-constants 'symbols) . font-lock-constant-face)
    ("\\<\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*(" 1 font-lock-function-name-face)
    ("\\<\\(0x[0-9a-fA-F]+\\|\\(?:[0-9]+\\(?:\\.[0-9]+\\)?\\)\\)\\>" . font-lock-constant-face)
    ("\\(?:\\.\\)\\s-*\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\>" 1 font-lock-variable-name-face)
    ("\\<class\\>\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\>" 1 font-lock-type-face)
    ("\\<class\\>\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-+<\\s-+\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\>"
     (1 font-lock-type-face)
     (2 font-lock-type-face))))

;;;###autoload
(define-derived-mode bs-mode prog-mode "BS"
  "Major mode for editing BS source code."
  :syntax-table bs-mode-syntax-table
  (setq comment-start "//")
  (setq font-lock-defaults '(bs-font-lock-defaults))
  (add-hook 'compilation-filter-hook
            (lambda ()
              (let ((inhibit-read-only t))
                (ansi-color-apply-on-region (point-min) (point-max))))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.bs\\'" . bs-mode))

(provide 'bs-mode)

;;; bs-mode.el ends here
