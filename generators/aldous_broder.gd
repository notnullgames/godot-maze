# Aldous-Broder algorithm
# http://weblog.jamisbuck.org/2011/1/17/maze-generation-aldous-broder-algorithm.html

const maze = preload("res://maze.gd")

static func generate(width=10, height=10):
	var grid = maze.fill(width, height, 0)
	var pos = Vector2(randi() % width, randi() % height)
	var remaining = width * height - 1
	while remaining > 1:
		var directions = maze.random_shuffle([maze.N, maze.S, maze.E, maze.W])
		for dir in directions:
			var n = pos + maze.D[dir]
			if n.x >= 0 && n.y >= 0 && n.x < width && n.y < height:
				if grid[n.y][n.x] == 0:
					grid[pos.y][pos.x] |= dir
					grid[n.y][n.x] |= maze.O[dir]
					remaining -= 1
				pos = n
				break
	return grid
