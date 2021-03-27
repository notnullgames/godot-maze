# Simply close all doors

const maze = preload("res://maze.gd")

static func generate(width=10, height=10):
	return maze.fill(width, height, 0)
