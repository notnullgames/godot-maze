# Recursive Division algorithm
# http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm.html

const maze = preload("res://maze.gd")

const HORIZONTAL = 1
const VERTICAL = 2

static func choose_orientation(width, height):
	if width < height:
		return HORIZONTAL
	elif height < width:
		return VERTICAL
	else:
		return HORIZONTAL if (randi() % 2) == 0 else VERTICAL

static func divide(grid, pos, width, height, orientation):
	if width <= 2 || height <= 2:
		return
	var horizontal = orientation == HORIZONTAL
	
	# where will the wall be drawn from?
	var w = pos + Vector2(randi() % (width-2), 0)
	if horizontal:
		w = pos + Vector2(0, randi() % (height-2))
	
	# where will the passage through the wall exist?
	var p = w + Vector2(0, randi() % height)
	if horizontal:
		p = w + Vector2(randi() % width, 0)
	
	# what direction will the wall be drawn?
	var d = Vector2(
	  1 if horizontal else 0,
	  0 if horizontal else 1
	)
	
	# how long will the wall be?
	var length = width if horizontal else height
	
	# what direction is perpendicular to the wall?
	var dir = maze.S if horizontal else maze.E
	
	for i in range(length):
		if w != p:
			grid[w.y][w.x] |= dir
		w += d
	
	var n = pos
	var wn = width if horizontal else pos.x + width - w.x - 1
	var hn =  pos.y + height - w.y-1 if horizontal else height
	divide(grid, n, int(wn), int(hn), choose_orientation(wn, hn))
	return grid

static func generate(width=10, height=10):
	randomize()
	var grid = maze.fill(width, height, 0)
	divide(grid, Vector2.ZERO, width, height, choose_orientation(width, height))
	return grid
