# Growing Tree algorithm
# http://weblog.jamisbuck.org/2011/1/27/maze-generation-growing-tree-algorithm.html

const maze = preload("res://maze.gd")

static func generate(width=10, height=10):
	var grid = maze.fill(width, height, 0)
	var pos = Vector2(randi() % width, randi() % height)
	return grid
