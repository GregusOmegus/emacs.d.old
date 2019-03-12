;;--------------------------------------------------
;; package archive setup / general package loading
;;--------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(nyan-mode 1)


;;--------------------------------------------------
;; general settings
;;--------------------------------------------------
(setq line-number-mode t)
(setq column-number-mode t)
(require 'font-lock) ;; syntax highlighting
(require 'uniquify) ;; unique buffer names for same-named files
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")
(ido-mode 1)
(setq ido-enable-flex-matching t)


;;--------------------------------------------------
;; custom functions
;;--------------------------------------------------
;; do a find/replace in all open buffers
(defun query-replace-in-open-buffers (arg1 arg2)
  "query-replace in all open buffers"
  (interactive "sIn all open buffers, replace: \nswith: ")
  (mapcar
   (lambda (x)
     (find-file x)
     (save-excursion
       (beginning-of-buffer)
       (query-replace arg1 arg2)))
   (delq
    nil
    (mapcar
     (lambda (x)
       (buffer-file-name x))
     (buffer-list)))))

;; isearch-yank-region: when in isearch mode, yank current region to minibuffer
(defun isearch-yank-region ()
  (interactive)
  (if (region-active-p)
      (progn (isearch-yank-internal (lambda () (mark)))
	          (deactivate-mark))
    (message "No active region")))
(define-key isearch-mode-map "\C-r" 'isearch-yank-region)


;;--------------------------------------------------
;; Code settings
;;--------------------------------------------------

;; Custom cc-mode style
(defconst grog-style
  '((c-tab-always-indent .t)
    (c-comment-only-line-offset .0)
    (c-indent-comments-syntactically-p .t)
    (c-hanging-braces-alist . ((substatement-open after)
			              (brace-list-open)))
    (c-hanging-colons-alist . ((member-init-intro before)
			              (inher-intro)
				             (case-label after)
					            (label after)
						           (access-label after)))
    (c-cleanup-list . ((scope-operator)
		              (empty-defun-braces)
			             (defun-close-semi)))
    ;; TBD
    ;; (c-offsets-alist . ((arglist-close . c-lineup-arglist)
    ;; (access-label . -4)
    ;; (member-init-intro . 4)))

    )
  "grog style")

(defun grog-c-mode-common-hook ()
  ;; add grog-style and set for current buffer
  (c-add-style "grog" grog-style t)

  (setq tab-width 8 indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq options-save-faces t))
(add-hook 'c-mode-common-hook 'grog-c-mode-common-hook)


;;--------------------------------------------------
;; custom-set-variables
;;--------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(load-home-init-file t t)
 '(mouse-wheel-mode t nil (mwheel))
 '(mouse-yank-at-point t)
 '(package-selected-packages
   (quote
    (elpy company-anaconda company helm magit nyan-mode)))
 '(paren-mode (quote sexp) nil (paren))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil))


;;--------------------------------------------------
;; Session management
;; Customized to maintain a single desktop save file
;;--------------------------------------------------
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")
(add-hook 'desktop-after-read-hook
	    '(lambda ()
	            (setq desktop-dirname-tmp desktop-dirname)
		         (desktop-remove)
			      (setq desktop-dirname desktop-dirname-tmp)))
(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))
;; function to restore saved session
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No saved desktop found.")))
;; function to save the desktop session
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
	    (desktop-save-in-desktop-dir)
	(message "Session not saved."))
    (desktop-save-in-desktop-dir)))
;; hook to query whether to restore session at startup
(add-hook 'after-init-hook
	    '(lambda ()
	            (if (saved-session)
			 (if (y-or-n-p "Restore desktop? ")
			          (session-restore)))))

;; TODO: tool-bar-here-mode, hooked to gdb-mode
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
