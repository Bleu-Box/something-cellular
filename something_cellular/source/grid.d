// Handles all the cells and rules
module grid;

class Grid {
	immutable int width = 100;
	immutable int height = 100;
	enum CellType { BLACK, WHITE, RED, YELLOW, PURPLE };
	CellType[width][height] cells;
	
	this() {
		import std.random : dice;
		// initialize cells randomly
		foreach(y, row; this.cells) {
			foreach(x, cell; row) {
				if(dice(90, 10) == 1) {
					this.cells[y][x] = CellType.WHITE;
				} else {
					this.cells[y][x] = CellType.BLACK;
				} 
			}
		}
	}

	void update() {
		CellType[height][width] newCells;

		foreach(y, row; cells) {
			foreach(x, cell; row) {
				newCells[y][x] = doRule(x, y);
			}
		}

		cells = newCells;
	}

	// these rules are carefully fine-tuned to create really cool emergent behaviors
	private CellType doRule(int x, int y) {
		CellType cell = cells[y][x];
		int white_nbs = nbs(x, y, CellType.WHITE);
		int black_nbs = nbs(x, y, CellType.BLACK);
		int red_nbs = nbs(x, y, CellType.RED);
		int yellow_nbs = nbs(x, y, CellType.YELLOW);
		int purple_nbs = nbs(x, y, CellType.PURPLE);
		int live_nbs = white_nbs+red_nbs+yellow_nbs+purple_nbs;
		
		if(cell == CellType.WHITE) {
			if(cells[y][(x+width-1)%width] == CellType.YELLOW
			   || cells[y][(x+width+1)%width] == CellType.YELLOW)
				return CellType.BLACK;
		        if(live_nbs < 2) return CellType.RED;
			else if(white_nbs > 3) return CellType.PURPLE;
			return cell;
		} else if(cell == CellType.BLACK) {
			if(purple_nbs == 5) return CellType.PURPLE;
			else if(yellow_nbs == 3) return CellType.YELLOW;
			else if(red_nbs == 3) return CellType.RED;
			else if(white_nbs == 3) return CellType.WHITE;
			return cell;
		} else if(cell == CellType.RED) {
			if(red_nbs > 3) return CellType.BLACK;
			else if(white_nbs != 0) return cell;
			else if(live_nbs < 2) return CellType.YELLOW;
			return cell;
		} else if(cell == CellType.YELLOW) {
			if(live_nbs < 2) return CellType.PURPLE;
			else if(yellow_nbs > 3) return CellType.BLACK;
			return cell;
		} else if(cell == CellType.PURPLE) {
			if(cells[(y+height-1)%height][x] == CellType.WHITE
			   || cells[(y+height+1)%height][x] == CellType.WHITE)
				return cell;
			else if(purple_nbs < 2 || live_nbs > 3) return CellType.BLACK;
			return CellType.WHITE;
		}

	        assert(0);
	}
	
	// get the neighboring cells of a certain type
	private int nbs(int x, int y, CellType type) {
		import std.algorithm.searching : count;
		
		int top = (y+height-1)%height;
		int bottom = (y+1)%height;
		int left = (x+width-1)%width;
		int right = (x+1)%width;

	        auto neighbs = [cells[top][left], cells[top][x], cells[top][right],
				cells[y][left],                  cells[y][right],
				cells[bottom][left], cells[bottom][x], cells[bottom][right]];

		return count(neighbs, type);
	}
}
