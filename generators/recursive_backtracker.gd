# Recursive Backtracker algorithm
# Detailed description: http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking

var rng = RandomNumberGenerator.new()

func backtrack(maze, position):
	maze.set_visited(position)
	var directions = maze.directions_from(position)
	
	# remove visited
	for i in range(len(directions)-1):
		# for some reason I need to re-check this here
		if i < len(directions):
			var d = directions[i]
			if maze.is_visited(position + maze.directions[d]):
				directions.remove(i)
	
	# while there are possible travel directions from this cell
	while len(directions) > 0:
		# choose random direction
		var rand_i = rng.randi_range(0, len(directions)-1)
		var dirn = directions[rand_i]
		
		directions[rand_i] = directions[len(directions)-1]
		directions.pop_back()
		
		# if this direction leads to an unvisited cell:
		# carve and recurse into this new cell
		var new_position = position + maze.directions[dirn]
		if !maze.is_visited(new_position):
			maze.set_open(position, dirn)
			backtrack(maze, new_position)

func generate(maze):
	rng.randomize()
	maze.reset_doors()
	var position = Vector2(rng.randi_range(0, maze.width-1), rng.randi_range(0, maze.height-1))
	backtrack(maze, position)
	maze.reset_visited()
