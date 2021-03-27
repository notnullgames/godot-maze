# Binary Tree algorithm
# http://weblog.jamisbuck.org/2011/2/1/maze-generation-binary-tree-algorithm.html

const maze = preload("res://maze.gd")

static func generate(width=10, height=10):
	randomize()
	var grid = maze.fill(width, height, 0)
	for y in range(height):
		for x in range(width):
			var dirs = []
			if y:
				dirs.append(maze.N)
			if x:
				dirs.append(maze.W)
			if (len(dirs)):
				var dir = maze.random_element(dirs)
				var newp = Vector2(x, y) + maze.D[dir]
				grid[y][x] |= dir
				grid[newp.y][newp.x] |= maze.O[dir]
	return grid
