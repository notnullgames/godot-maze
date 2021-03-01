# generate a maze tilemap
# reworked ideas from https://kidscancode.org/blog/2018/08/godot3_procgen1/

tool
extends TileMap

# These come from http://www.astrolog.org/labyrnth/algrithm.htm
# adapted from https://github.com/shironecko/LuaMaze
enum algo {
	aldous_broder,
	binary_tree,
	eller,
	growing_tree,
	hunt_and_kill,
	kruskal,
	prim,
	recursive_backtracker,
	recursive_division,
	sidewinder,
	wilson
}

# hack to create a quick GUI
# TODO: eventually this should be an inspector plugin:
# https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html
export (bool) var show_start = true
export (bool) var show_end = true
export (int) var width = 20
export (int) var height = 20
export(algo) var algorithm = algo.recursive_backtracker
export(bool) var generate setget handle_generate

# called when this is put in user's scene
func _enter_tree():
	pass

# handler for button (checkbox, actually) above
func handle_generate(value):
	match algorithm:
		algo.recursive_backtracker:
			var r = recursive_backtracker(self, width, height, show_start, show_end)
#			print_maze_hex(r[0])
		_:
			print("%s not implemented." % algo.keys()[algorithm])


const N = 1
const E = 2
const S = 4
const W = 8
var cell_walls = {
	Vector2(0, -1): N,
	Vector2(1, 0): E, 
	Vector2(0, 1): S,
	Vector2(-1, 0): W
}
	
# returns an array of cell's unvisited neighbors
func get_unvisited_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

# show the tile index numbers on console
func print_maze_hex(grid):
	for row in grid:
		var o = ""
		for c in row:
			o += "%X " % c
		print(o)

func recursive_backtracker(tileMap:TileMap, maze_width:int, maze_height:int, start_visible:bool, end_visible:bool):
	randomize()
	var unvisited = []  # array of unvisited tiles
	var maze = []
	var stack = []
	# fill the map with solid tiles
	tileMap.clear()
	for y in range(maze_height):
		maze.append([])
		for x in range(maze_width):
			maze[y].append(0)
			unvisited.append(Vector2(x, y))
			tileMap.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2.ZERO
	var start = current + Vector2.ZERO
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = get_unvisited_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = tileMap.get_cellv(current) - cell_walls[dir]
			var next_walls = tileMap.get_cellv(next) - cell_walls[-dir]
			maze[current.y][current.x] = current_walls
			tileMap.set_cellv(current, current_walls)
			tileMap.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	var end = current + Vector2.ZERO
	if start_visible:
		tileMap.set_cellv(start, 16 )
	if end_visible:
		tileMap.set_cellv(end, 17)
	return [maze, start, end]

