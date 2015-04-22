(load (spheres/sdl2 sdl2) compile: #t)
(load (spheres/core base) compile: #t)

;;(load "r678")
; ;(myfunc 1234)
;; (display (printf/ret "Yo! wassap!"))
;; (newline)

(define *window* #f)
(define *screen-width* #f)
(define *screen-height* #f)
(define *renderer* #f)

(define *current-time* 0)
(define *last-time* 0)
(define *last-time-move* 0)

(define *square* #f)
(define *cursor* #f)
(define *toggle-menu* #f)
(define *blinking* #f)
(define *moving* #f)
(define *menu-option1* #f)
(define *menu-option2* #f)
(define *menu-option3* #f)
(define *menu-option4* #f)

(define *current-color* #f)
;;TODO
;;SPLASH

(define (boolean->string val) 
  (if val "#t" "#f"))

(define (init-menu!)
  (set! *menu-option1* (alloc-SDL_Rect))
  (SDL_Rect-h-set! *menu-option1* (inexact->exact (round (/ *screen-height* 8))))
  (SDL_Rect-w-set! *menu-option1* (SDL_Rect-h *menu-option1*))
  (SDL_Rect-x-set! *menu-option1* (inexact->exact (round (- *screen-width* (SDL_Rect-w *menu-option1*)))))
  (SDL_Rect-y-set! *menu-option1* 0)
  
  (set! *menu-option2* (alloc-SDL_Rect))
  (SDL_Rect-h-set! *menu-option2* (inexact->exact (round (/ *screen-height* 8))))
  (SDL_Rect-w-set! *menu-option2* (SDL_Rect-h *menu-option2*))
  (SDL_Rect-x-set! *menu-option2* (inexact->exact (round (- *screen-width* (* (SDL_Rect-w *menu-option2*) 2)))))
  (SDL_Rect-y-set! *menu-option2* 0)

  (set! *menu-option3* (alloc-SDL_Rect))
  (SDL_Rect-h-set! *menu-option3* (inexact->exact (round (/ *screen-height* 8))))
  (SDL_Rect-w-set! *menu-option3* (SDL_Rect-h *menu-option3*))
  (SDL_Rect-x-set! *menu-option3* (inexact->exact (round (- *screen-width* (* (SDL_Rect-w *menu-option3*) 3)))))
  (SDL_Rect-y-set! *menu-option3* 0)
  
  (set! *menu-option4* (alloc-SDL_Rect))
  (SDL_Rect-h-set! *menu-option4* (inexact->exact (round (/ *screen-height* 8))))
  (SDL_Rect-w-set! *menu-option4* (SDL_Rect-h *menu-option4*))
  (SDL_Rect-x-set! *menu-option4* (inexact->exact (round (- *screen-width* (* (SDL_Rect-w *menu-option4*) 4)))))
  (SDL_Rect-y-set! *menu-option4* 0))

(define (init-square!)
  (set! *square* (alloc-SDL_Rect))
  (SDL_Rect-h-set! *square* (inexact->exact (round (/ *screen-height* 10))))
  (SDL_Rect-w-set! *square* (SDL_Rect-h *square*))
  (SDL_Rect-x-set! *square* (inexact->exact (round (-(/ *screen-width* 2) (/ (SDL_Rect-w *square*) 2)))))
  (SDL_Rect-y-set! *square* (inexact->exact (round (-(/ *screen-height* 2) (/ (SDL_Rect-w *square*) 2))))))


(define (init-cursor!)
  (set! *cursor* (alloc-SDL_Rect))
  (let ((square-x (SDL_Rect-x *square*))
	(square-y (SDL_Rect-y *square*))
	(square-w (SDL_Rect-w *square*))
	(square-h (SDL_Rect-h *square*))
	(cursor-w (SDL_Rect-w *cursor*))	  	)
    (SDL_Rect-h-set! *cursor* (inexact->exact (round (/ square-w 2))))
    (SDL_Rect-w-set! *cursor* (inexact->exact (round (/ square-h 2))))
    (SDL_Rect-x-set! *cursor* (inexact->exact (round (- (+ square-x (/ square-w 2)) (/ cursor-w 2)))))
    (SDL_Rect-y-set! *cursor* (inexact->exact (round (- (+ square-y (/ square-w 2)) (/ cursor-w 2)))))))

(define (keep-cursor-on!)
  (let ((square-x (SDL_Rect-x *square*))
	(square-y (SDL_Rect-y *square*))
	(square-w (SDL_Rect-w *square*))
	(square-h (SDL_Rect-h *square*))
	(cursor-w (SDL_Rect-w *cursor*)))
    (SDL_Rect-x-set! *cursor* (inexact->exact (round (- (+ square-x (/ square-w 2)) (/ cursor-w 2)))))
    (SDL_Rect-y-set! *cursor* (inexact->exact (round (- (+ square-y (/ square-w 2)) (/ cursor-w 2)))))))

(define (show-menu!)
  (SDL_SetRenderDrawColor *renderer* 255 51 51 255)
  (SDL_RenderDrawRect *renderer* *menu-option1*)
  (SDL_RenderFillRect *renderer* *menu-option1*)
  (SDL_SetRenderDrawColor *renderer* 51 255 51 255)
  (SDL_RenderDrawRect *renderer* *menu-option2*)
  (SDL_RenderFillRect *renderer* *menu-option2*)
  (SDL_SetRenderDrawColor *renderer* 51 255 255 255)
  (SDL_RenderDrawRect *renderer* *menu-option3*)
  (SDL_RenderFillRect *renderer* *menu-option3*)
  (SDL_SetRenderDrawColor *renderer* 255 255 255 255)
  (SDL_RenderDrawRect *renderer* *menu-option4*)
  (SDL_RenderFillRect *renderer* *menu-option4*)
  (SDL_SetRenderDrawColor *renderer* 255 51 51 255)
  (SDL_RenderFillRect *renderer* *menu-option1*) )

(define (show-square!)
  (set-current-color-to-render!)
  (SDL_RenderDrawRect *renderer* *square*)
  (SDL_RenderFillRect *renderer* *square*)
  (SDL_RenderPresent *renderer*))

(define (show-cursor!)
  (SDL_SetRenderDrawColor *renderer* 0 0 0 0)
  (SDL_RenderDrawRect *renderer* *cursor*)
  (SDL_RenderFillRect *renderer* *cursor*)
  (SDL_RenderPresent *renderer*))

(define (toggle-blink!)
  (if (equal? *blinking* #f)
      (set! *blinking* #t)
      (set! *blinking* #f)))

(define (set-current-time!)
  (set! *current-time* (SDL_GetTicks)))

(define (blink!)
  (when
   (> *current-time* (+ *last-time* 400))
   (if *blinking*
       (show-cursor!)
       (show-square!))
   (toggle-blink!)
   (set! *last-time* *current-time*)))

(define (move!)
  (let* ((x (SDL_Rect-x *square*))
	 (y (SDL_Rect-y *square*))
	 (screen-percentage 1)
	 (step (inexact->exact (round  (* (/ *screen-height* 100) screen-percentage)))))
    
    (when
     (> *current-time* (+ *last-time-move* 5))
     (cond
      ((eq? *moving* 'up)
       (if (>= y step) 
	   (SDL_Rect-y-set! *square* (- y step))
	   (unless (<= y 0)
		   (SDL_Rect-y-set! *square* 0)))
       (show-square!))
      ((eq? *moving* 'down)
       (let ((*screen-height* (- *screen-height* (SDL_Rect-h *square*))))
	 (if (>= (- *screen-height* y) step) 
	     (SDL_Rect-y-set! *square* (+ y step))
	     (unless (>= y *screen-height*)
		     (SDL_Rect-y-set! *square* *screen-height*))))
       (show-square!))
      ((eq? *moving* 'right)
       (let ((*screen-width* (- *screen-width* (SDL_Rect-w *square*))))
	 (if (>= (- *screen-width* x) step) 
	     (SDL_Rect-x-set! *square* (+ x step))
	     (unless (>= x *screen-width*)
		     (SDL_Rect-x-set! *square* *screen-width*))))
       (show-square!))
      ((eq? *moving* 'left)
       (if (>= x step) 
	   (SDL_Rect-x-set! *square* (- x step))
	   (unless (<= x 0)
		   (SDL_Rect-x-set! *square* 0)))
       (show-square!)))
     (keep-cursor-on!)
     (set! *last-time-move* *current-time*))))

(define (clear!)
  (SDL_SetRenderDrawColor *renderer* 0 0 0 0)
  (SDL_RenderClear *renderer*))

(define (change-current-color! r g b)
  (SDL_Color-r-set! *current-color* r)
  (SDL_Color-g-set! *current-color* g)
  (SDL_Color-b-set! *current-color* b))

(define (set-current-color-to-render!)
  (SDL_SetRenderDrawColor *renderer* (SDL_Color-r *current-color*)  (SDL_Color-g *current-color*) (SDL_Color-b *current-color*) 255))

(define (init-app!)
  (let ((mode* (alloc-SDL_DisplayMode))
        (flags-sdl SDL_INIT_VIDEO))
    (when (< (SDL_Init flags-sdl) 0)
          (error-log "Couldn't initialize SDL!"))
    (SDL_GetCurrentDisplayMode 0 mode*)
    (set! *screen-width* (SDL_DisplayMode-w mode*))
    (set! *screen-height* (SDL_DisplayMode-h mode*))
    (set! *window*
          (SDL_CreateWindow "Liquidood" 
			    SDL_WINDOWPOS_CENTERED 
			    SDL_WINDOWPOS_CENTERED
                            *screen-width* *screen-height*
			    ;;SDL_WINDOW_ALLOW_HIGHDPI
			    (bitwise-ior 
			     ;;SDL_WINDOW_OPENGL
			     SDL_WINDOW_FULLSCREEN_DESKTOP
			     ;;SDL_WINDOW_RESIZABLE
			     ;;SDL_WINDOW_BORDERLESS
			     ;;SDL_WINDOW_ALLOW_HIGHDPI
			     )))
    (unless *window* (error-log "Unable to create render window" (SDL_GetError)))
    
    (set! *renderer*
	  (SDL_CreateRenderer *window* 0 SDL_RENDERER_ACCELERATED))

    (clear!)

    (SDL_SetRenderDrawColor *renderer* 255 51 51 255)
    
    (set! *current-color*
	  (alloc-SDL_Color))
    
    (change-current-color! 255 255 255)
    (set-current-color-to-render!)
    (init-square!)
    (init-cursor!)
    (init-menu!)))

(define (game-loop!)
  (let ((*event (alloc-SDL_Event)))
    (call/cc
     (lambda (quit)
       (let main-loop ()
	 (let event-loop ()  
	   (when (= 1 (SDL_PollEvent *event))
		 (let ((event-type (SDL_Event-type *event)))
		   (set! *blinking* #f)
		   (cond 
		    ((= event-type SDL_KEYDOWN)
		     (let* ((kevt* (SDL_Event-key *event))
			    (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt*))))
		       (cond
			((= key SDLK_ESCAPE)
			 (quit))
			((= key SDLK_UP)
			 (set! *moving* 'up))
			((= key SDLK_DOWN)
			 (set! *moving* 'down))
			((= key SDLK_RIGHT)
			 (set! *moving* 'right))
			((= key SDLK_LEFT)
			 (set! *moving* 'left))
			(else 
			 (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION 
					 (string-append "Key: " (number->string key)))))))
		    ((= event-type SDL_KEYUP)
		     (let* ((kevt* (SDL_Event-key *event))
			    (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt*))))
		       (cond
	       		((= key SDLK_UP)
			 (set! *moving* #f))
			((= key SDLK_DOWN)
			 (set! *moving* #f))
			((= key SDLK_RIGHT)
			 (set! *moving* #f))
			((= key SDLK_LEFT)
			 (set! *moving* #f)))))
		    
		    ((= event-type SDL_MOUSEBUTTONDOWN)
		     
		     (let* ((mouse-event* (SDL_Event-button *event))
			    (mouse-x (SDL_MouseButtonEvent-x mouse-event*))
			    (mouse-y (SDL_MouseButtonEvent-y mouse-event*))
			    (bwidth (SDL_Rect-w *menu-option1*))
			    (bheight (SDL_Rect-h *menu-option1*)))

		       (when (< mouse-y bheight)
			     (cond
			      ((> mouse-x (- *screen-width* bwidth))			       
			       (change-current-color! 255 51 51)
			       (set-current-color-to-render!))
			      ((and(> mouse-x (- *screen-width* (* bwidth 2))) (< mouse-x (- *screen-width* bwidth)))
			       (change-current-color! 51 255 51)
			       (set-current-color-to-render!))
			      ((and(> mouse-x (- *screen-width* (* bwidth 3))) (< mouse-x (- *screen-width* (* bwidth 2))))
			       (change-current-color! 51 255 255)
			       (set-current-color-to-render!))
			      ((and(> mouse-x (- *screen-width* (* bwidth 4))) (< mouse-x (- *screen-width* (* bwidth 3))))
			       (change-current-color! 255 255 255)
			       (set-current-color-to-render!))))))))
		 (event-loop))
	   (set-current-time!)
	   (move!)
	   (show-menu!)
	   (blink!)
	   (main-loop))))))
  (SDL_DestroyWindow *window*)
  (SDL_DestroyRenderer *renderer*)
  (SDL_Quit))

(init-app!)
(game-loop!)
