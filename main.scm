(load (spheres/sdl2 sdl2) compile: #t)
(load (spheres/core base) compile: #t)

(define *window* #f)
(define *screen-width* #f)
(define *screen-height* #f)
(define *renderer* #f)
(define *square* #f)
(define *toggle-menu* #f)
(define *blinking* #f)
(define *blink-counter* #f)
(define *menu-option1* #f)
(define *menu-option2* #f)
(define *menu-option3* #f)
(define *menu-option4* #f)

(define *current-color* #f)
;;TODO
;; COLOUR MENU, CLICKS ON MENU, CHANGE COLORS
;; FIX FILL SQUARE OR WORKAROUND

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
  (cond 
   ((equal? *blinking* #f)
    (SDL_SetRenderDrawColor *renderer* 0 0 0 0)
    (SDL_RenderDrawRect *renderer* *square*))
   (else
    (set-current-color-to-render!)
    (SDL_RenderDrawRect *renderer* *square*)))
  (set! *blink-counter* (- *blink-counter* 1))
  (set-current-color-to-render!)
  (SDL_RenderFillRect *renderer* *square*)
  (SDL_RenderPresent *renderer*))

(define (toggle-blink!)
  (if (equal? *blinking* #f)
      (set! *blinking* #t)
      (set! *blinking* #f)))

(define (blink-countdown!)
  (cond
   ((<= *blink-counter* 0)
    (set! *blink-counter* 30)
    (toggle-blink!))))

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
    (set! *blink-counter* 100)
    (SDL_SetRenderDrawColor *renderer* 255 51 51 255)
    
    (set! *current-color*
	  (alloc-SDL_Color))
    
    (change-current-color! 255 255 255)
    (set-current-color-to-render!)
    (init-square!)
    (init-menu!)))

(define (game-loop!)
  (let ((*event (alloc-SDL_Event)))
    (call/cc
     (lambda (quit)
       (let main-loop ()
	 (let event-loop ()  
	   (when (= 1 (SDL_PollEvent *event))
		 (let ((event-type (SDL_Event-type *event)))
		   (cond 
		    ((= event-type SDL_KEYDOWN)
		     (let* ((kevt* (SDL_Event-key *event))
			    (key (SDL_Keysym-sym (SDL_KeyboardEvent-keysym kevt*)))
			    (x (SDL_Rect-x *square*))
			    (y (SDL_Rect-y *square*))
			    (screen-percentage 1)
			    (step (inexact->exact (round  (* (/ *screen-height* 100) screen-percentage)))))
		       (cond
			((= key SDLK_ESCAPE)
			 (quit))

			((= key SDLK_UP)
			 (if (>= y step) 
			     (SDL_Rect-y-set! *square* (- y step))
			     (unless (<= y 0)
				     (SDL_Rect-y-set! *square* 0))))

			((= key SDLK_DOWN)
			 (let ((*screen-height* (- *screen-height* (SDL_Rect-h *square*))))
			   (if (>= (- *screen-height* y) step) 
			       (SDL_Rect-y-set! *square* (+ y step))
			       (unless (>= y *screen-height*)
				       (SDL_Rect-y-set! *square* *screen-height*)))))

			((= key SDLK_RIGHT)
			 (let ((*screen-width* (- *screen-width* (SDL_Rect-w *square*))))
			   (if (>= (- *screen-width* x) step) 
			       (SDL_Rect-x-set! *square* (+ x step))
			       (unless (>= x *screen-width*)
				       (SDL_Rect-x-set! *square* *screen-width*)))))

			((= key SDLK_LEFT)
			 (if (>= x step) 
			     (SDL_Rect-x-set! *square* (- x step))
			     (unless (<= x 0)
				     (SDL_Rect-x-set! *square* 0))))
			(else 
			 (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION 
					 (string-append "Key: " (number->string key)))))))
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
		 (blink-countdown!)
		 (pp *blink-counter*)
		 (show-menu!)
		 (show-square!)
		 (event-loop)))
	 (main-loop)))))
  (pp "Destroying")
  (SDL_DestroyWindow *window*)
  (SDL_DestroyRenderer *renderer*)
  (SDL_Quit))

(init-app!)
(game-loop!)
