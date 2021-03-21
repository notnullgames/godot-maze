extends  Node

# this is a base-class for mazes, implemented as binary-flag grid
# use other scripts to implement actual algorithms or render-methods
# based on ideas from LuaMaze, but I use a binary-flag data-model

var maze = []
var width = 0
var height = 0

# bit-flags for grid-squares
const N = 1
const S = 2
const E = 4
const W = 8
const VISITED = 16

# offsets for differnt directions
const directions = {
	N: Vector2(0, -1),
	E: Vector2(1, 0),
	S: Vector2(0, 1),
	W: Vector2(-1, 0)
}

# what direction is opposite of each?
const opposites = {
	N: S,
	E: W,
	S: N,
	W: E
}

# utility function to parse strings as directions
func parse_direction(direction):
	if typeof(direction) == TYPE_INT:
		return direction
	else:
		var d = direction[0].to_upper()
		if d == "N":
			return N
		elif d == "S":
			return S
		elif d == "E":
			return E
		elif d == "W":
			return W
		else:
			return 0

# utility function to see if a number has a bit-flag set
func hasbit (x, p):
	return fposmod(x, p + p) >= p

# utility function to set an array of bit-flags
func setbits(x, pa):
	for p in pa:
		x = x if hasbit(x, p) else x + p
	return x

# utility function to unset an array of bit-flags
func unsetbits(x, pa):
	for p in pa:
		x = x - p if hasbit (x, p) else x
	return x

func _init(w, h):
	height = h
	width = w
	reset_doors()

# initialize maze-grid with all closed-doors
func reset_doors(closed = true):
	maze = []
	for y in range(height):
		maze.append([])
		for x in range(width):
			maze[y].append(15 if closed else 0)

# remove visited flag for all positions
func reset_visited():
	for y in range(height):
		for x in range(width):
			maze[y][x] = unsetbits(maze[y][x], [VISITED])

# output a simple string representation of current maze
func to_string(wall = "#", passage = " "):
	var result = ""
	var verticalBorder = ""
	for i in range(width):
		verticalBorder += wall + ( wall if is_closed(Vector2(i, 0), N) else passage )
	verticalBorder += wall
	result += verticalBorder + "\n"
	for y in range(height):
		var row = self.maze[y]
		var line = wall if is_closed(Vector2(0, y), W) else passage
		var underline = wall
		for x in range(width):
			var cell = self.maze[y][x]
			line += " " + (wall if is_closed(Vector2(x, y), E) else passage)
			underline += (wall if is_closed(Vector2(x, y), S) else passage) + wall
		result += line + "\n" + underline + "\n"
	return result

# wrapper for godot
func _to_string():
	return to_string()

# output more compact text of maze
# see explanatory code here:
# https://github.com/konsumer/LuaMaze/blob/braille/source/braille.lua
# this only prints on the real console (godot console can't deal)
func to_braille():
	var result = ""
	for y in range(height):
		for x in range(width):
			var block = [0x2800, 0x2800]
			if is_closed(Vector2(x, y), N):
				block[0] = setbits(block[0], [0x01, 0x08])
				block[1] = setbits(block[1], [0x01, 0x08])
			if is_closed(Vector2(x, y), S):
				block[0] = setbits(block[0], [0x40, 0x80])
				block[1] = setbits(block[1], [0x40, 0x80])
			if is_closed(Vector2(x, y), E):
				block[1] = setbits(block[1], [0x08, 0x10, 0x20, 0x80])
			if is_closed(Vector2(x, y), W):
				block[0] = setbits(block[0], [0x01, 0x02, 0x04, 0x40])
			result += char(block[0]) + char(block[1])
		result += "\n"
	return result

# is this direction open at this location?
func is_open(location:Vector2, direction): 
	return !hasbit(maze[location.y][location.x], parse_direction(direction))

# is this direction closed at this location?
func is_closed(location:Vector2, direction):
	return hasbit(maze[location.y][location.x], parse_direction(direction))

func is_visited(location:Vector2):
	return hasbit (maze[location.y][location.x], VISITED)

# set a direction open at a specific location
func set_open(location:Vector2, direction, do_opposite = true):
	var d = parse_direction(direction)
	maze[location.y][location.x]  = unsetbits(maze[location.y][location.x], [d])
	if do_opposite:
		var shift = location + directions[d]
		if shift.x >= 0 and shift.x < width and shift.y >= 0 and shift.y < height:
			set_open(shift, opposites[d], false)

# set a direction closed at a specific location
func set_closed(location:Vector2, direction, do_opposite = true):
	var d = parse_direction(direction)
	maze[location.y][location.x]  = setbits(maze[location.y][location.x], [d])
	if do_opposite:
		var shift = location + directions[d]
		if shift.x >= 0 and shift.x < width and shift.y >= 0 and shift.y < height:
			set_closed(shift, opposites[d], false)

# vist or unvisit a square
func set_visited(location:Vector2, visited = true):
	if visited:
		maze[location.y][location.x]  = setbits(maze[location.y][location.x], [VISITED])
	else:
		maze[location.y][location.x]  = unsetbits(maze[location.y][location.x], [VISITED])

# get a list of directions that are open from a position
func directions_from(location:Vector2):
	var da = []
	for name in directions.keys():
		var shift = location + directions[name]
		if shift.x >= 0 and shift.x < width and shift.y >= 0 and shift.y < height:
			da.append(name)
	return da

# apply a maze-generation algorithm
func generate(algo):
	var file2Check = File.new()
	var path = "res://generators/" + algo + ".gd"
	if file2Check.file_exists(path):
		var a = load(path).new()
		a.generate(self)
	else:
		print(algo, " is not created.")
