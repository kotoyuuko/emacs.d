;;; kotoyuuko/emacs.d --- kotoyuuko's Emacs config file

;;; Commentary:

;; Copyright (c) 2019 kotoyuuko
;;
;; Author: kotoyuuko <kokoro@core.moe>
;; URL: https://github.com/kotoyuuko/emacs.d
;;
;; This file is not part of GNU Emacs.
;;
;;; License: The Unlicense


;;; Code:

;; Set user name and email
(setq user-full-name "kotoyuuko")
(setq user-mail-address "kokoro@core.moe")

;; Hide splash screen
(setq inhibit-splash-screen t)

;; Hide menubar, toolbar and scrollbar
(require 'menu-bar)
(menu-bar-mode 0)
(require 'tool-bar)
(tool-bar-mode 0)
(require 'scroll-bar)
(scroll-bar-mode 0)

;; Ignore ring bell
(setq ring-bell-function 'ignore)

;; Set max column
(setq-default fill-column 80)

;; Disable auto backup
(setq make-backup-files nil)

;; Disable auto save
(setq auto-save-default nil)

;; Save last place
(save-place-mode 1)

;; Set default tab and space
(setq-default c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode nil)

;; Kill ring
(setq kill-ring-max 200)
(setq kill-do-not-save-duplicates t)
(setq kill-whole-line t)

;; Highlights the current cursor line
(global-hl-line-mode t)

;; Set elpa mirror to tuna
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			 ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; Initialize packages
(unless (bound-and-true-p package--initialized)
  (setq package-enable-at-startup nil)
  (package-initialize))

;; Setup `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; Setup `material-theme'
(use-package material-theme
  :ensure t
  :config (load-theme 'material t))

;; Setup `nlinum'
(use-package nlinum
  :ensure t
  :hook (after-init . global-nlinum-mode)
  :init (setq nlinum-format " %d "))

;; Setup `delsel'
(use-package delsel
  :ensure t
  :hook (after-init . delete-selection-mode))

;; Setup `autorevert'
(use-package autorevert
  :ensure t
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; Setup `hungry-delete'
(use-package hungry-delete
  :ensure t
  :diminish
  :hook (after-init . global-hungry-delete-mode)
  :config (setq-default hungry-delete-chars-to-skip " \t\f\v"))

;; Setup `which-key'
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; Setup `paren'
(use-package paren
  :ensure t
  :hook (after-init . show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t)
  (setq show-paren-when-point-in-periphery t))

;; Setup `quickrun'
(use-package quickrun
  :bind (("C-<f5>" . quickrun)
         ("C-c x" . quickrun)))

;; Setup `ace-window'
(use-package ace-window
  :ensure t
  :init
  (global-set-key [remap other-window] 'ace-window))

;; Setup `counsel'
(use-package counsel
  :ensure t
  :bind (("M-y" . counsel-yank-pop)))

;; Setup `ivy'
(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))

;; Setup `swiper'
(use-package swiper
  :ensure try
  :bind (("C-s" . swiper)
	     ("C-r" . swiper)
	     ("C-c C-r" . ivy-resume)
	     ("M-x" . counsel-M-x)
	     ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

;; Setup `avy'
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

;; Setup `auto-complete'
(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

;; Setup `company'
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (global-company-mode t))

;; Setup `flycheck'
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; Setup `yasnippet'
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; Setup `yasnippet-snippets'
(use-package yasnippet-snippets
  :ensure t)

;; Setup `undo-tree'
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

;; Git related modes
(use-package gitattributes-mode
  :ensure t)
(use-package gitconfig-mode
  :ensure t)
(use-package gitignore-mode
  :ensure t)

;; EditorConfig
(use-package editorconfig
  :ensure t
  :diminish editorconfig-mode
  :hook (after-init . editorconfig-mode))

;; Go mode
(use-package go-mode
  :ensure t
  :bind (:map go-mode-map
              ([remap xref-find-definitions] . godef-jump)
              ("C-c R" . go-remove-unused-imports)
              ("<f1>" . godoc-at-point))
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'gofmt-before-save)

  (use-package go-dlv
    :ensure t)
  (use-package go-fill-struct
    :ensure t)
  (use-package go-impl
    :ensure t)
  (use-package go-rename
    :ensure t)
  (use-package golint
    :ensure t)

  (use-package go-tag
    :bind (:map go-mode-map
                ("C-c t" . go-tag-add)
                ("C-c T" . go-tag-remove))
    :config (setq go-tag-args (list "-transform" "camelcase")))

  (use-package gotest
    :ensure t
    :bind (:map go-mode-map
                ("C-c a" . go-test-current-project)
                ("C-c m" . go-test-current-file)
                ("C-c ." . go-test-current-test)
                ("C-c x" . go-run)))

  (use-package go-gen-test
    :ensure t
    :bind (:map go-mode-map
                ("C-c C-t" . go-gen-test-dwim)))

  (use-package go-eldoc
    :ensure t
    :hook (go-mode . go-eldoc-setup))
  
  (use-package company-go
    :ensure t
    :defines company-backends
    :init (cl-pushnew 'company-go company-backends)))

;; Automatically added by emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-eldoc company-go go-gen-test gotest golint go-rename go-impl go-fill-struct go-dlv swiper ace-window which-key nlinum material-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
