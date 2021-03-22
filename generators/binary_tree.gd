# Binary tree algorithm
# Detailed description: http://weblog.jamisbuck.org/2011/2/1/maze-generation-binary-tree-algorithm

var rng = RandomNumberGenerator.new()

func generate(maze):
	rng.randomize()
	maze.reset_doors()
	
	# wander through the maze
	for y in range(maze.height-1):
		for x in range(maze.width-1):
			# and randomly open east or south doors
			if x != (maze.width-1) and (y == (maze.height-1) or rng.randi_range(0, 1) == 1):
				maze.set_open(Vector2(x, y), "E")
			else:
				maze.set_open(Vector2(x, y), "S")
	maze.set_closed(Vector2(maze.height-1, maze.width-1), 'S')
