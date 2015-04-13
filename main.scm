(load (spheres/sdl2 sdl2) compile: #t)
(load (spheres/core base) compile: #t)

(define *window* #f)
(define *screen-width* #f)
(define *screen-height* #f)
(define *renderer* #f)
(define *square* #f)

;;TODO
;; COLOUR MENU, CLICKS ON MENU, CHANGE COLORS
;; FIX FILL SQUARE OR WORKAROUND

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
    (SDL_SetRenderDrawColor *renderer* 0 0 0 0)
    (SDL_RenderClear *renderer*)
    (SDL_SetRenderDrawColor *renderer* 255 255 255 255)
    
    (set! *square*
	  (alloc-SDL_Rect))

    (pp *screen-width*)
    (pp *screen-height*)
    (SDL_Rect-h-set! *square* (inexact->exact (round (/ *screen-height* 10))))
    (SDL_Rect-w-set! *square* (SDL_Rect-h *square*))
    (SDL_Rect-x-set! *square* (inexact->exact (round (-(/ *screen-width* 2) (/ (SDL_Rect-w *square*) 2)))))
    (SDL_Rect-y-set! *square* (inexact->exact (round (-(/ *screen-height* 2) (/ (SDL_Rect-w *square*) 2)))))))

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
			    (step (inexact->exact (round  (* (/ *screen-height* 100) 1)))))
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
				     (SDL_Rect-y-set! *square* 0))))
			(else 
			 (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION 
					 (string-append "Key: " (number->string key)))))))
		    ((= event-type SDL_MOUSEBUTTONDOWN)
		     ;;TODO
		     )))
		 
		 (SDL_RenderDrawRect *renderer* *square*)
		 ;(SDL_RenderFillRect *renderer* *square*)
		 (SDL_RenderPresent *renderer*)
		 (event-loop)))
	 
	 (main-loop)))))
  (pp "Destroying")
  (SDL_DestroyWindow *window*)
  (SDL_DestroyRenderer *renderer*)
  (SDL_Quit))

(init-app!)
(game-loop!)
