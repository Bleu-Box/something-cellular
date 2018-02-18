import graphics;
import grid;

void main() {
	Grid grid = new Grid();
	Graphics graphics = new Graphics("Cellular Automata of Some Sort", grid.width, grid.height, 5, 5);
        
	while(true) {	
		if(graphics.exitRequested()) break;

		graphics.renderGrid(grid);
		grid.update();
	}	
}
