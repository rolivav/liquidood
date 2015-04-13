#include  <stdio.h>
#include <SDL2/SDL.h>

int main (int argc, char* args[])
{
        SDL_SetRelativeMouseMode(SDL_TRUE);

        SDL_Window *screen;

        SDL_Init (SDL_INIT_VIDEO);

        screen = SDL_CreateWindow (
                "My Game Window",
                SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED,
                320,240,
                SDL_WINDOW_RESIZABLE
        );


        if (screen == NULL)
        {
                printf("Could not create a window: %s\n", SDL_GetError());
                return 1;
        }

        SDL_Renderer *sdlRenderer = SDL_CreateRenderer(screen, -1, 0);

        SDL_SetRenderDrawColor(sdlRenderer, 0, 0, 0, 255);

        SDL_RenderClear(sdlRenderer);

        SDL_RenderPresent(sdlRenderer);

        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "linear");

        SDL_RenderSetLogicalSize(sdlRenderer, 320, 240);

        SDL_SetRenderDrawColor(sdlRenderer,0,0,255,255);

        SDL_Rect r;
        r.x = 160;
        r.y = 120;
        r.w = 5;
        r.h = 5;

        SDL_RenderFillRect(sdlRenderer, &r);

        SDL_RenderPresent(sdlRenderer);

        SDL_Delay (9000);
        SDL_DestroyWindow(screen);
        SDL_Quit();
        return 0;
}
