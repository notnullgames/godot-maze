# generate a maze tilemap
# I saw this after I made this all, which is also a decent method: 
# https://kidscancode.org/blog/2018/08/godot3_procgen1/

tool
extends TileMap

# These come from http://www.astrolog.org/labyrnth/algrithm.htm
# adapted from https://github.com/shironecko/LuaMaze
enum algo {
	aldous_broder,
#	binary_tree,
#	eller,
#	growing_tree,
#	hunt_and_kill,
#	kruskal,
#	prim,
	recursive_backtracker,
#	recursive_division,
#	sidewinder,
#	wilson
}

# hack to create a quick GUI
# TODO: eventually this should be an inspector plugin:
# https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html
export (int) var width = 20
export (int) var height = 20
export(algo) var algorithm = algo.aldous_broder
export(bool) var generate setget handle_generate

var rng = RandomNumberGenerator.new()

# directionals as bitwise data
const N = 1
const S = 2
const E = 4
const W = 8

var D = {
	E: Vector2(1, 0),
	W: Vector2(-1, 0),
	N: Vector2(0, -1),
	S: Vector2(0, 1)
}

var DIRECTIONS = [N, S, E, W]
var OPPOSITE = { E:W, W:E, N:S, S:N }

# display a maze on console
func print_maze(grid):
	var out = " "
	for x in range(width * 2 - 1):
		out += "_"
	out += "\n"
	for y in range(height):
		out += "|"
		for x in range(width):
			if grid[y][x] & S != 0:
				out += " "
			else:
				out += "_"
			if grid[y][x] & E != 0:
				if (grid[y][x] | grid[y][x+1]) & S != 0:
					out += " "
				else:
					out += "_"
			else:
				out += "|"
		out += "\n"
	print(out)

# show the tile index numbers on console
func print_maze_hex(grid):
	for row in grid:
		var o = ""
		for c in row:
			o += "%X " % c
		print(o)

# turn a maze into tiles
# use a tileset like this: https://kidscancode.org/blog/img/4bit_road_tiles.png
func tile_maze(tilemap, grid):
	for y in range(height):
		for x in range(width):
			tilemap.set_cell(x, y, grid[y][x])

# adapted from http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking.html
func gen_recursive_backtracker(start, grid):
	var directions = DIRECTIONS.duplicate()
	directions.shuffle()
	for direction in directions:
		var n = start + D[direction]
		if n.y < height and n.y >= 0 and n.x < width and n.x >= 0 and grid[n.y][n.x] == 0:
			grid[start.y][start.x] += direction
			grid[n.y][n.x] += OPPOSITE[direction]
			gen_recursive_backtracker(n, grid)

# generate a maze
func create_maze(width: int, height: int, algorithm: int):
	assert(algorithm in algo.values(), "Invalid algorithm.")
	# gen an all-floor maze
	var maze = []
	for y in range(0, height):
		maze.append([])
		for x in range(0, width):
			maze[y].append(0)
	match algorithm:
		algo.recursive_backtracker:
			var start = Vector2(rng.randi_range(0, width), rng.randi_range(0, height))
			gen_recursive_backtracker(start, maze)
							
		_:
			print("%s not implemented" % algo.keys()[algorithm])
	return maze
	


## PLUGIN MAZE-TYPE STUFF

# called when this is put in user's scene
func _enter_tree():
	rng.randomize()
#	create_maze(self, width, height, wall_tile, floor_tile, algorithm)

# handler for button (checkbox, actually) above
func handle_generate(value):
	var maze = create_maze(width, height, algorithm)
	tile_maze(self, maze)
	print_maze(maze)
	print_maze_hex(maze)


