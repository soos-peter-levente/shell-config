;; -*- mode: lisp; author: spl; license: MIT -*- ;;

;;;; StumpWM Configuration
(in-package :stumpwm)

;;;;;;;;;;;;;;;;;
;; KEYBINDINGS ;;
;;;;;;;;;;;;;;;;;

;; Write keybindings in a simpler fashion
(defmacro define-keys (map binding-alist)
  `(progn ,@(loop for (key . command) in binding-alist
                  collect `(define-key ,map (kbd ,key) ,@command))))

;; top-level
(define-keys *top-map*
  (;; keymap prefixes
   ("s-d" '*describe-map*)
   
     ;; commands and reload 
   ("s-." "colon")
   ("s--" "loadrc")

   ;; access predefined groups
   ("s-1" "gselect 1")
   ("s-2" "gselect 2")
   ("s-3" "gselect 3")
   ("s-4" "gselect 4")
   ("s-5" "gselect 5")
   ("s-g" "grouplist")

   ;; move between windows
   ("s-l" "move-focus right")
   ("s-j" "move-focus left")
   ("s-i" "move-focus up")
   ("s-k" "move-focus down")

   ;; move windows in group
   ("M-s-l" "move-window right")
   ("M-s-j" "move-window left")
   ("M-s-i" "move-window up")
   ("M-s-k" "move-window down")

   ;; move windows between groups
   ("s-'" "gmove 1")
   ("s-\"" "gmove 2")
   ("s-+" "gmove 3")
   ("s-!" "gmove 4")
   ("s-%" "gmove 5")
   
   ;; resize windows
   ("s-s" "iresize")

   ;; fullscreen & lock
   ("s-f" "fullscreen")
   ("s-c" "exec xscreensaver-command -lock")

   ;; splitting windows
   ("s-h" "hsplit")
   ("s-v" "vsplit")

   ;; cycle through windows
   ("s-TAB" "fnext")
   ("M-TAB" "pull-hidden-next")

   ;; kill windows & frames
   ("s-q" "kill")
   ("s-r" "remove")

   ;; run a program
   ("s-a" "exec")
   
   ;; a few specific program bindings
   ("s-n" "exec st -e tmux")
   ("s-p" "exec pcmanfm")

   ;; the emacs daemon should be running by the time X/stumpwm
   ;; starts - we attach with a client with the keys below.
   ("s-o" "exec emacsclient -c") ;; run with GUI or in xterm
   ("s-t" "exec st -e env TERM=xterm-256color emacsclient -t")

   ;; Volume control
   ("XF86AudioRaiseVolume" "exec pactl set-sink-volume 0 +5%")
   ("XF86AudioLowerVolume" "exec pactl set-sink-volume 0 -5%")
   ("XF86AudioMute" "exec pactl set-sink-volume 0 0%")
   
   ;; misc
   ("s-:" "eval")
   ("s-e" "gselect lisp")
   ))

;; iresize - modify the iresize.lisp defaults a bit here
(define-interactive-keymap
    (iresize tile-group) (:on-enter #'setup-iresize
                          :on-exit #'resize-unhide
                          :abort-if #'abort-resize-p)
  ((kbd "i") "resize-direction up")
  ((kbd "k") "resize-direction down")
  ((kbd "j") "resize-direction left")
  ((kbd "l") "resize-direction right"))

;; root-map
(set-prefix-key (kbd "C-."))

;; describe map
(defvar *describe-map* (make-sparse-keymap)
  "Use 'describe' commands with a prefix key map.")

(define-keys *describe-map*
    (("f"  "describe-function")
     ("v"  "describe-variable")
     ("k"  "describe-key")
     ("c"  "describe-command")
     ))

;;;;;;;;;;;;;
;; STARTUP ;;
;;;;;;;;;;;;;

;; Create default groups 
(run-commands "grename lisp"
              "gnew http"
              "gnew bash"
              "gnew play"
              "gnew misc")

;; Select Lisp group automatically
(run-commands "gselect lisp")

;; Get an emacsclient screen with a SLIME REPL running
(run-or-raise "emacsclient -c" () nil)
(run-shell-command "feh --bg-scale ~/documents/img/wall.jpg")

;; Modules
(set-module-dir #P"/home/spl/common-lisp/stumpwm/contrib/")

;; mode-line - set variables and toggle it once
(setf *mode-line-position* :bottom
      *screen-mode-line-format* (list "[^B%n^b] %W | %d"))

;; turn on mode-line
(when (not (head-mode-line (current-head)))
  (toggle-mode-line (current-screen) (current-head)))

;;;;;;;;;;;;;;;;
;; APPEARANCE ;;
;;;;;;;;;;;;;;;;

;; Font
(set-font "-*-terminus-medium-*-normal-*-12-120-72-72-c-60-iso8859-*")

;; colors & borders
(setf *window-border-style* :tight)
(set-border-color "#3a3a3a")
(set-focus-color "#a9a9a9")
(set-unfocus-color "#3a3a3a")

;;;;;;;;;;;;
;; SERVER ;;
;;;;;;;;;;;;
(defconstant +stumpwm-image-port+ 7777)

(require :swank)
(swank-loader:init)
(swank:create-server :port +stumpwm-image-port+
                     :style swank:*communication-style*
                     :dont-close t)
