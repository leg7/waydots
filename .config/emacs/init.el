;;--------- leg7 emacs config for emacs 28
;; Set alpha-background when emacs v29 comes out
;; and remove packages that will be built-in

;;------ UI ------

(set-frame-parameter (selected-frame) 'alpha-background 96)
(add-to-list 'default-frame-alist '(alpha-background . (96 . 91)))

(add-to-list 'default-frame-alist '(font . "monospace-10.5"))
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 0)
(blink-cursor-mode 0)
(global-hl-line-mode)
(setq use-file-dialog nil)

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(tab-bar-mode) ;; Map tab-next and tab-previous
(setq tab-bar-show 0)
(global-tab-line-mode) ;; Map previous-buffer, next-buffer, ido-switch-buffer

(setq display-time-default-load-average nil)
(column-number-mode)

(global-whitespace-mode)
(setq whitespace-style '(face lines-tail trailing indentation indentation::tabs indentation::space))

;;------ Behaviour ------

(global-unset-key (kbd "C-z"))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen 1)
(setq ring-bell-function 'ignore)
(setq uniquify-buffer-name-style 'forward)
(setq completion-auto-wrap t)
(filesets-init)
(savehist-mode)
(recentf-mode)
(save-place-mode)
(global-auto-revert-mode)
(global-subword-mode)
(auto-save-mode) ;; See M-x recover-file or M-x recover-session
(add-hook 'text-mode-hook 'flyspell-mode)
(setq flymake-no-changes-timeout nil)

;; Style
(setq c-default-style '((java-mode   . "java")
                        (awk-mode    . "awk")
                        (python-mode . "python")
                        (other       . "linux")))

(setq-default indent-tabs-mode nil)
(defun infer-indentation-style ()
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(add-hook 'prog-mode-hook 'infer-indentation-style)

;; Don't litter
(setq native-comp-async-report-warnings-errors nil)
(setq package-user-dir "~/.local/share/emacs/elpa/"
      url-history-file "~/.local/share/emacs/url-history"
      recentf-save-file "~/.local/share/emacs/recentf"
      savehist-file "~/.local/share/emacs/history")

(setq backup-directory-alist '(("." . "~/.local/share/emacs/backups/"))
      delete-old-versions t
      version-control t
      kept-new-versions 9
      kept-old-versions 9)

(setq auto-save-interval 20
      auto-save-timeout 3
      auto-save-no-message t
      kill-buffer-delete-auto-save-files t
      auto-save-file-name-transforms '((".*" "~/.local/share/emacs/auto-saves/" t))
      auto-save-list-file-prefix "~/.local/share/emacs/auto-saves/")

;; test when v29 comes out
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache "~/.local/cache/emacs/eln-cache/"))

(setq custom-file (locate-user-emacs-file "custom-variables.el"))
(load custom-file 'noerror 'nomessage)

;;----------- Packages --------------

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(or (file-exists-p package-user-dir) (package-refresh-contents))
(package-initialize)

(unless (package-installed-p 'use-package) ;;  built-in by v29
  (package-install 'use-package))
(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package dracula-theme
  :config (load-theme 'dracula t))

(use-package diminish
  :hook (prog-mode . (lambda() (diminish 'hs-minor-mode)))
  :config
  (diminish 'global-whitespace-mode)
  (diminish 'abbrev-mode)
  (diminish 'subword-mode)
  (diminish 'eldoc-mode))

(use-package rainbow-mode
  :hook prog-mode
  :diminish)

;; (use-package dimmer ;; Not using until they fix it with corefu
;;   :config
;;   (dimmer-mode)
;;   (setq dimmer-fraction 0.25))

;; Completion

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-count 15)
  (vertico-resize t)
  (vertico-cycle t))

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package marginalia
  :init (marginalia-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-quit-no-match t)
  :config
  (corfu-popupinfo-mode)
  (setq tab-always-indent 'complete))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("TAB" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-symbol)
         ("C-c p a" . cape-abbrev)
         ("C-c p i" . cape-ispell)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Remove in v29
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-sgml)
  (add-to-list 'completion-at-point-functions #'cape-rfc1345)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-to-list 'completion-at-point-functions #'cape-ispell)
  (add-to-list 'completion-at-point-functions #'cape-dict)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  :config
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

(use-package eglot ;; Built-in by v29
  :hook (prog-mode . eglot-ensure))

;; (use-package lsp-java)

(use-package haskell-mode)
(use-package nix-mode :mode "\\.nix\\'")

;; Vim mode

(use-package undo-tree
  :hook (prog-mode . global-undo-tree-mode)
  :diminish
  :custom
  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-relative-timestamps nil)
  (undo-tree-history-directory-alist '(("." . "~/.local/share/emacs/undo-tree/"))))

(use-package evil
  :hook (prog-mode . hs-minor-mode) ;; for folding (replace with better tree sitter version in v29 pls)
  :init (evil-mode)
  :custom
  (evil-want-keybinding nil)
  (evil-undo-system 'undo-tree)
  (evil-overriding-maps nil)
  (evil-want-C-u-scroll t)
  (evil-want-Y-yank-to-eol t)
  (evil-cross-lines t)
  (evil-bigword "\(\)\[\]\{\}^ \t\r\n")
  (evil-esc-delay 0))

; (use-package evil-numbers
;   :keymap

(use-package evil-collection
  :diminish evil-collection-unimpaired-mode
  :init (evil-collection-init))

(use-package evil-commentary
  :after evil
  :diminish
  :config (evil-commentary-mode))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode))

(use-package evil-matchit
  :after evil
  :config (global-evil-matchit-mode))

(use-package evil-lion
  :after evil
  :config (evil-lion-mode))

(use-package evil-snipe
  :after evil
  :diminish evil-snipe-local-mode
  :config (evil-snipe-mode)
  (evil-snipe-override-mode))

(use-package evil-anzu
  :after evil
  :diminish anzu-mode
  :init (global-anzu-mode))

(use-package evil-easymotion ;; Replace with custom tree-sitter evil text obj
  :after evil
  :config (evilem-default-keybindings "SPC"))

(use-package evil-exchange
  :after evil
  :config (evil-exchange-install))

(use-package evil-args
  :after evil
  :config ;; idk how to do this with :bind
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)
  (define-key evil-normal-state-map "L" 'evil-forward-arg)
  (define-key evil-normal-state-map "H" 'evil-backward-arg)
  (define-key evil-motion-state-map "L" 'evil-forward-arg)
  (define-key evil-motion-state-map "H" 'evil-backward-arg)
  (define-key evil-normal-state-map "K" 'evil-jump-out-args))
