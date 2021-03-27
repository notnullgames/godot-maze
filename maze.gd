# shared maze utils and constants

# directions
const N = 0x1
const S = 0x2
const E = 0x4
const W = 0x8

# opposite directions
const O = { N:S, S:N, E:W, W:E }

# Vector offsets, by direction
const D = {
	N: Vector2.UP,
	S: Vector2.DOWN,
	E: Vector2.RIGHT,
	W: Vector2.LEFT
}

# get 1 random element of an array
static func random_element(array):
	return array[randi() % array.size()]

# shuffle an array
static func random_shuffle(list):
	var shuffledList = [] 
	var indexList = range(list.size())
	for i in range(list.size()):
		var x = randi() % indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList

# create an array filed with a value
static func fill(width=10, height=10, value=0):
	var maze = []
	for y in range(width):
		maze.append([])
		for x in range(height):
			maze[y].append(value)
	return maze

# output more compact text of maze
# see explanatory code here:
# https://github.com/konsumer/LuaMaze/blob/braille/source/braille.lua
# this only prints on the real console (godot console can't deal)
static func get_braille(maze):
	var result = ""
	for y in range(len(maze)):
		for x in range(len(maze[0])):
			var block = [0x2800, 0x2800]
			if maze[y][x] & N == 0:
				block[0] |= 0x1 | 0x8
				block[1] |= 0x1 | 0x8
			if maze[y][x] & S == 0:
				block[0] |= 0x40 | 0x80
				block[1] |= 0x40 | 0x80
			if maze[y][x] & E == 0:
				block[1] |= 0x8 | 0x10 | 0x20 | 0x80
			if maze[y][x] & W == 0:
				block[0] |= 0x1 | 0x2 | 0x4 | 0x40
			result += char(block[0]) + char(block[1])
		result += "\n"
	return result

# output a simple string representation of current maze
static func get_string(maze, wall = "#", passage = " "):
	var result = ""
	var verticalBorder = ""
	for i in range(len(maze[0])):
		verticalBorder += wall + ( wall if maze[0][i] & N == N else passage )
	verticalBorder += wall
	result += verticalBorder + "\n"
	for y in range(len(maze)):
		var row = maze[y]
		var line = wall if maze[y][0] & W == W else passage
		var underline = wall
		for x in range(len(maze[0])):
			var cell = maze[y][x]
			line += " " + (wall if maze[x][y] & E == E else passage)
			underline += (wall if maze[x][y] & S == S else passage) + wall
		result += line + "\n" + underline + "\n"
	return result
