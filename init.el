;; Initialize the package system.
(eval-and-compile
  (if (require 'cask)
      (cask-initialize)
    (warn "Cask is not installed!")))
(package-initialize)

;; Make use-package available.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; pallet
(use-package pallet :no-require t :ensure t
  :commands (pallet-init)
  :config
  (condition-case nil
      (pallet-init)
    (error nil)))

;; Theming
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :defer t
  :init
  (load-theme 'sanityinc-tomorrow-eighties t))

;; global settings
(global-hl-line-mode)
(setq inhibit-startup-message t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default indent-tabs-mode nil)

;; autocomplete
(use-package auto-complete
  :ensure t
  :config
  (progn
    (require 'auto-complete-config)
    (ac-set-trigger-key "TAB")
    (ac-config-default)
    (setq ac-delay 0.02)
    (setq ac-use-menu-map t)
    (setq ac-menu-height 50)
    (setq ac-use-quick-help nil)
    (setq ac-fuzzy-enable t)
    (setq ac-modes '(emacs-lisp-mode
                     lisp-mode
                     lisp-interaction-mode
                     slime-repl-mode
                     c-mode
                     cc-mode
                     c++-mode
                     go-mode
                     java-mode
                     python-mode
                     lua-mode
                     scheme-mode
                     js2-mode
		     makefile-mode
                     markdown-mode
                     sh-mode
                     latex-mode
                     LaTeX-mode
                     plain-TeX-mode))))

;; autopair
(use-package autopair
  :ensure t
  :config
  (progn
    (autopair-global-mode 1)
    (setq autopair-autowrap t)))

;; flycheck
(use-package flycheck
  :diminish flycheck-mode
  :init
  (global-flycheck-mode))

;; flyspell - use aspell instead of ispell
(use-package flyspell
  :commands (flyspell-mode flyspell-prog-mode)
  :config
  (setq ispell-program-name (executable-find "aspell")
                                ispell-extra-args '("--sug-mode=ultra")))
;; helm
(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (helm-mode 1)))

;; git interface
(use-package magit
  :ensure t
  :diminish auto-revert-mode
  :commands (magit-status magit-checkout)
  :bind (("C-x g" . magit-status))
  :init
  (setq magit-revert-buffers 'silent
        magit-push-always-verify nil
        git-commit-summary-max-length 70))

;; common lisp
(use-package lisp
  :mode "\\.lisp$"
  :config
  (progn
    (setq inferior-lisp-program "/usr/local/bin/sbcl")
    (define-key lisp-mode-map (kbd "C-c C-s") 'slime)))

(use-package slime
  :commands slime
  :config
  (progn
    (setq slime-net-coding-system 'utf-8-unix)
    (slime-setup '(slime-repl slime-fancy slime-fuzzy))))

(use-package ac-slime
  :defer t
  :init
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
  (with-eval-after-load 'auto-complete
    (add-to-list 'ac-modes 'slime-repl-mode)))

;; json
(use-package json
  :mode "\\.json$"
  :config
  (setq js-indent-level 4))

;; markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;; toml
(use-package toml-mode
  :mode "\\.toml$")

;; yaml
(use-package yaml-mode
  :mode "\\.ya?ml\'")

;; python
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :config
  (setq indent-tabs-mode nil)
  (setq indent-level 4)
  (setq python-indent 4)
  (setq tab-width 4))

;; web
(use-package web-mode
  :ensure t
  :mode (("\\.html\\.erb\\'" . web-mode)
         ("\\.eex\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; c/c++/objc
(use-package irony
  :ensure t
  :config
  (progn
    (custom-set-variables '(irony-additional-clang-options '("-std=c++14")))
    (add-hook 'c++-mode-hook 'irony-mode)
    (add-hook 'c-mode-hook 'irony-mode)
    (add-hook 'objc-mode-hook 'irony-mode)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)))
