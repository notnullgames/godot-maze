# Aldous-Broder algorithm
# Detailed description: http://weblog.jamisbuck.org/2011/1/17/maze-generation-aldous-broder-algorithm

var rng = RandomNumberGenerator.new()

func generate(maze):
	rng.randomize()
	maze.reset_doors()
	var remaining = (maze.width * maze.height) - 1
	
	# wander randomly through the maze
	var position = Vector2(rng.randi_range(0, maze.width-1), rng.randi_range(0, maze.height-1))
	maze.set_visited(position)
	
	while remaining > 0:
		var directions = maze.directions_from(position)
		var dirn = directions[rng.randi_range(0, len(directions)-1)]
		var testpos = position + maze.directions[dirn]
		if !maze.is_visited(testpos):
			maze.set_visited(testpos)
			maze.set_open(position, dirn)
			remaining -= 1
		position = testpos
