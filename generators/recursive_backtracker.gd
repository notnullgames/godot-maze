# Recursive Backtracking algorithm
# http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking.html

const maze = preload("res://maze.gd")

static func carve_passages_from(position, grid):
	var directions = maze.random_shuffle([maze.N, maze.S, maze.E, maze.W])
	for direction in directions:
		var newp = position + maze.D[direction]
		if newp.x >= 0 && newp.y >= 0 && newp.x < len(grid[0]) && newp.y < len(grid) && grid[newp.y][newp.x] == 0:
			grid[position.y][position.x] |= direction
			grid[newp.y][newp.x] |= maze.O[direction]
			carve_passages_from(newp, grid)

static func generate(width=10, height=10):
	randomize()
	var grid = maze.fill(width, height, 0)
	carve_passages_from(Vector2(randi() % width, randi() % height), grid)
	return grid
