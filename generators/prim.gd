# Prim's algorithm
# http://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm.html

const maze = preload("res://maze.gd")

const IN = 0x10
const FRONTIER = 0x20

static func add_frontier(pos, grid, frontier):
	if pos.x >= 0 && pos.y >= 0 &&  pos.x < len(grid[0]) && pos.y < len(grid) && grid[pos.y][pos.x] == 0:
		grid[pos.y][pos.x] |= FRONTIER
		frontier.append(pos)

static func mark(pos, grid, frontier):
	grid[pos.y][pos.x] |= IN
	add_frontier(pos + Vector2.LEFT, grid, frontier)
	add_frontier(pos + Vector2.RIGHT, grid, frontier)
	add_frontier(pos + Vector2.UP, grid, frontier)
	add_frontier(pos + Vector2.DOWN, grid, frontier)

static func neighbors(pos, grid):
	var n = []
	if pos.x > 0 && grid[pos.y][pos.x-1] & IN != 0:
		n.append(pos + Vector2.LEFT)
	if pos.x+1 < len(grid[0]) && grid[pos.y][pos.x+1] & IN != 0:
		n.append(pos + Vector2.RIGHT)
	if pos.y > 0 && grid[pos.y-1][pos.x] & IN != 0:
		n.append(pos + Vector2.UP)
	if pos.y+1 < len(grid) && grid[pos.y+1][pos.x] & IN != 0:
		n.append(pos + Vector2.DOWN)
	return n

static func direction(f: Vector2, t: Vector2):
	if f.x < t.x:
		return maze.E
	if f.x > t.x:
		return maze.W
	if f.y < t.y:
		return maze.S
	if f.y > t.y:
		return maze.N

static func generate(width=10, height=10):
	randomize()
	var grid = maze.fill(width, height, 0)
	var frontier = []
	mark(Vector2(randi() % width, randi() % height), grid, frontier)
	while len(frontier) > 0:
		frontier = maze.random_shuffle(frontier)
		var pos = frontier.pop_back()
		var n = maze.random_element(neighbors(pos, grid))
		var dir = direction(pos, n)
		grid[pos.y][pos.x] |= dir
		grid[n.y][n.x] |= maze.O[dir]
		mark(pos, grid, frontier)
	return grid

