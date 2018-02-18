// Draws the cells using SDL2
module graphics;

import derelict.sdl2.sdl;

import grid;

class Graphics {
	int width, height;
        int cellWidth, cellHeight;
	private SDL_Window* window;
	private SDL_Renderer* renderer;

	// initializes SDL
	this(const char* title, int width, int height, int cellWidth, int cellHeight) {
		this.width = width;
		this.height = height;
		this.cellWidth = cellWidth;
		this.cellHeight = cellHeight;

		DerelictSDL2.load();
		SDL_Init(SDL_INIT_VIDEO);
		this.window = SDL_CreateWindow(title, 100, 100, width*cellWidth, height*cellHeight, 0);
		this.renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	}

	// checks to see if user wants to quit
	bool exitRequested() {
		SDL_Event e;
		return SDL_PollEvent(&e) && e.type == SDL_QUIT;
	}

	// draws all the cells
	void renderGrid(Grid grid) {
		foreach(y, row; grid.cells) {
			foreach(x, cell; row) {
			        drawCell(x, y, cell);
			}
		}
		
		SDL_RenderPresent(renderer);
	}

	private void drawCell(int x, int y, Grid.CellType type) {
		SDL_Rect rect;
		rect.x = x*cellWidth;
		rect.y = y*cellHeight;
		rect.w = cellWidth;
		rect.h = cellHeight;

		alias CType = Grid.CellType;
		switch(type) {
		case CType.BLACK:
			SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);
			break;
		case CType.WHITE:
			SDL_SetRenderDrawColor(renderer, 237, 228, 180, 255);
			break;
		case CType.RED:
			SDL_SetRenderDrawColor(renderer, 100, 0, 0, 255);
			break;
		case CType.YELLOW:
			SDL_SetRenderDrawColor(renderer, 237, 228, 0, 255);
			break;
		case CType.PURPLE:
			SDL_SetRenderDrawColor(renderer, 105, 84, 173, 255);
			break;	
		default:
			assert(0); // default should never occur
		}

		SDL_RenderFillRect(renderer, &rect);
	}
}
