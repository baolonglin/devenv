(require 'package)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ("elpy" . "https://jorgenschaefer.github.io/packages/")
			 ))
(package-initialize)


(unless package-archive-contents
  (package-refresh-contents))

(setq package-list '(
                     js2-mode
                     yasnippet
                     auto-complete
                     react-snippets
                     flycheck
                     web-mode
                     web-beautify
                     helm
                     helm-projectile
                     helm-swoop
                     projectile
                     monokai-theme
                     undo-tree
                     neotree
                     irfc
                     edts
		     elpy
                     exec-path-from-shell
                     magit
                     ))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; bring shel exec path
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; js configuration
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(setq js2-highlight-level 3)

(custom-set-variables
  '(js2-basic-offset 2)
  '(js2-bounce-indet-p t)
  '(js-indent-level 2)
  '(web-mode-markup-indent-offset 2)
  '(web-mode-css-indent-offset 2)
  '(web-mode-code-indent-offset 2))

;;(define-key js-mode-map "{" 'paredit-open-curly)
;;(define-key js-mode-map "}" 'paredit-close-curly-and-newline)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; react snippets
(require 'react-snippets)

;; auto complete mode
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;; jshint with flycheck
(require 'flycheck)
(add-hook 'js-mode-hook
          (lambda () (flycheck-mode t)))

;; jsx with web-mode
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
           (if (equal web-mode-content-type "jsx")
             (let ((web-mode-enable-part-face nil))
               ad-do-it)
             add-to-it))

(flycheck-define-checker jsxhint-checker
                         " A JSX syntax and style checker based on ESLint."

                         :command ("jsxhint" source)
                         :error-patterns ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
                         :modes (web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (equal web-mode-content-type "jsx")
              (flycheck-select-checker 'jshint-checker)
              (flycheck-mode))))

(setq jsx-indent-level 2)
(add-hook 'jsx-mode-hook
          (lambda () (auto-complete-mode 1)))

;; this variables must be set before load helm-gtags
;; you can change to any prefix key of your choice
(setq helm-gtags-prefix-key "\C-cg")

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

;; Theme
(load-theme 'monokai t)
(tool-bar-mode -1)
(global-hl-line-mode t)
(toggle-frame-maximized)

(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono"))

;; feature for revert split pane config.
(winner-mode 1)

;; use Shift+arrow_keys to move cursor around split panes
(windmove-default-keybindings)

;; when cursor is on edge, move to the other side, as in a toroidal space
(setq windmove-wrap-around t)

;; Show column number
(setq column-number-mode t)

;; Show line number in program mode
(add-hook 'prog-mode-hook 'linum-mode)

;; helm configuration
(require 'helm-config)
(require 'helm-grep)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq
  helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
  helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.
  helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
  helm-candidate-number-limit 500 ; limit the number of displayed canidates
  helm-ff-file-name-history-use-recentf t
  helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
  helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non-nil
  ; useful in helm-mini that lists buffers

  )

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)

(global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)

(global-set-key (kbd "C-c h x") 'helm-register)
;; (global-set-key (kbd "C-x r j") 'jump-to-register)

(define-key 'help-command (kbd "C-f") 'helm-apropos)
(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key 'help-command (kbd "C-l") 'helm-locate-library)

;; use helm to list eshell history
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;;; Save current position to mark ring
(add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

;; show minibuffer history with Helm
(define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
(define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)

(define-key global-map [remap find-tag] 'helm-etags-select)

(define-key global-map [remap list-buffers] 'helm-buffers-list)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: helm-swoop                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Locate the helm-swoop folder to your path
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "C-c h o") 'helm-swoop)
(global-set-key (kbd "C-c s") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows t)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color t)

(helm-mode 1)

;; Package: undo-tree
;; GROUP: Editing -> Undo -> Undo Tree
(require 'undo-tree)
(global-undo-tree-mode)

;; Package: neotree
(require 'neotree)

;; Package: irfc
(require 'irfc)
(setq irfc-directory "/home/baolong/Workspace/rfc")
(setq irfc-assoc-mode t)

;; Package: edts
(add-hook 'after-init-hook 'my-after-init-hook)
(defun my-after-init-hook ()
  (require 'edts-start))

;; git
(require 'magit)
(setq magit-git-executable "/usr/local/bin/git")

;; bing dictionary query
(defun bing-dict ()
  "Search current word in bing dictionary."
  (interactive)
  (save-restriction
    (let (start end)
      (skip-chars-backward "A-Za-z0–9") (setq start (point))
      (skip-chars-forward "A-Za-z0–9") (setq end (point))
      (setq current-word (buffer-substring start end))
      (eww (concat "http://www.bing.com/dict/search?q=" current-word))
      (if (not (string= (buffer-name) "*eww*"))
          (switch-to-buffer-other-window "*eww*"))
      (hl-line-mode "*eww*")
      ;; wait for 2 second, because the buffer will refresh soon and it go back to top line.
      (sit-for 2)
      (search-forward current-word nil t 2)
      ;; mark the word for 1 second 
      (end-of-line)
      (set-mark (line-beginning-position))
      (sit-for 1)
      (deactivate-mark)
      )
    )
  )

(global-set-key (kbd "C-c q") 'bing-dict)

;; python
(elpy-enable)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3")

;; Basic editor control
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq tab-stop-list (number-sequence 2 200 2))
(desktop-save-mode 1)
(setq desktop-auto-save-timeout 15)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  )

