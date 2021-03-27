# Simply open all doors

const maze = preload("res://maze.gd")

static func generate(width=10, height=10):
	return maze.fill(width, height, maze.N + maze.S + maze.E + maze.W)
