;;; ox-textile.el --- Test code for ox-textile.el

;; Copyright (C) 2013 Yasushi SHOJI

;; Author: Yasushi SHOJI <yasushi.shoji@gmail.com>
;; Keywords: org, textile

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is test code for ox-textile.el.
;;
;; You can load this file with `load-file' and run the test with
;; `ert', Emacs Lisp Regression Testing.
;;
;; The test code depends on org-mode/testing/org-test.el.  So, make
;; sure you have org-test.el loaded or have it in your load path.
;; (add-to-list 'load-path "org-mode/testing")
;;
;; Obviously, you should have had ox-textile.el in your load path,
;; too.

;;; Code:
(require 'org-test)
(require 'ox-textile)

(defun org-textile-test-transcode-body (str1 str2)
  (should (equal (org-test-with-temp-text str1
		   (org-export-as 'textile nil nil t))
		 str2)))


;;; Inline Text Format
(ert-deftest test-org-textile/bold-to-bold ()
  (org-textile-test-transcode-body
   "*foo*"
   "*foo*\n"))

(ert-deftest test-org-textile/italic-to-italic ()
  (org-textile-test-transcode-body
   "/foo/"
   "__foo__\n"))

(ert-deftest test-org-textile/code-to-code ()
  (org-textile-test-transcode-body
   "~foo~"
   "@foo@\n"))

(ert-deftest test-org-textile/verbatim-to-code ()
  (org-textile-test-transcode-body
   "=foo="
   "@foo@\n"))

(ert-deftest test-org-textile/strikethrough-to-strikethrough ()
  (org-textile-test-transcode-body
   "+foo+"
   "-foo-\n"))


;;; Headlines to Titles
(ert-deftest test-org-textile/headline ()
  (org-textile-test-transcode-body
   "* 1st headline
** 2nd headline
*** 3rd headline
**** 4th headline
***** 5th headline
****** 6th headline
******* 7th headline"
"\nh2. 1st headline


h3. 2nd headline


h4. 3rd headline


h5. 4th headline


h6. 5th headline

* 6th headline
** 7th headline
"))


;;; List
(ert-deftest test-org-textile/unordered-list ()
  (org-textile-test-transcode-body
   "- list\n"
   "* list\n")
  (org-textile-test-transcode-body
   "- list\n- list"
   "* list\n* list\n")
  (org-textile-test-transcode-body
   "- list\n  - list"
   "* list\n** list\n")
  (org-textile-test-transcode-body
   "
- list
  - list
    - list
      - list
        - list"
   "* list
** list
*** list
**** list
***** list\n"))

(ert-deftest test-org-textile/ordered-list ()
  (org-textile-test-transcode-body
   "1. list 1
2. list 2
3. list 3
4. list 4
5. list 5
6. list 6
7. list 7
   1. list 7.1
      1. list 7.1.1
         1. list 7.1.1.1
            1. list 7.1.1.1.1"
   "# list 1
# list 2
# list 3
# list 4
# list 5
# list 6
# list 7
## list 7.1
### list 7.1.1
#### list 7.1.1.1
##### list 7.1.1.1.1
"))


;;; Example Blocks to Listing Blocks
(ert-deftest test-org-textile/example-block-to-listing-block ()
  (org-textile-test-transcode-body
   "#+BEGIN_EXAMPLE
int main(void) {
    printf(\"Hello, World\");

    return 0;
}
#+END_EXAMPLE"

   "bc.. int main(void) {
    printf(\"Hello, World\");

    return 0;
}

p. <!-- protecting the space after the dot -->
"))


;;; Tables
(ert-deftest test-org-textile/table-to-table ()
  (org-textile-test-transcode-body
   "| Peter |  1234 |  17 |
| Anna  |  4321 |  25 |
"
"| Peter | 1234 | 17 |
| Anna | 4321 | 25 |
")

  (org-textile-test-transcode-body
   "| Name  | Phone | Age |
|-------+-------+-----|
| Peter |  1234 |  17 |
| Anna  |  4321 |  25 |
"
   "|^.
|_. Name |_. Phone |_. Age |
|-.
| Peter | 1234 | 17 |
| Anna | 4321 | 25 |
")

  (let ((org-textile-use-thead nil))
    (org-textile-test-transcode-body
    "| Name  | Phone | Age |
|-------+-------+-----|
| Peter |  1234 |  17 |
| Anna  |  4321 |  25 |
"
    "|_. Name |_. Phone |_. Age |
| Peter | 1234 | 17 |
| Anna | 4321 | 25 |
")))

;;; Link
(ert-deftest test-ox-pukiwiki/link ()
  "Test Links."

  (org-textile-test-transcode-body
   "[[http://example.com][example]]"
   "\"example\":http://example.com\n")

  (org-textile-test-transcode-body
   "[[http://example.com]]"
   "\"http://example.com\":http://example.com\n")

  (org-textile-test-transcode-body
   "[[file:image.jpg]]"
   "!image.jpg!\n")

  (org-textile-test-transcode-body
   "[[file:image.jpg][my image]]"
   "!image.jpg(my image)!\n")

  (org-textile-test-transcode-body
   "[[/image.jpg][my image]]"
   "!/image.jpg(my image)!\n"))


(provide 'test-ox-textile)
;;; test-ox-textile.el end here
