# Prim's algorithm
# Detailed description: http://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm

var rng = RandomNumberGenerator.new()

func generate(maze):
	rng.randomize()
	maze.reset_doors()
	var frontiers = []
	var position = Vector2(rng.randi_range(0, maze.width-1), rng.randi_range(0, maze.height-1))
	
	var keepgoing = true
	while keepgoing:
		maze.set_visited(position)
		frontiers.erase(position)
	
		for dirn in maze.directions_from(position):
			# Marking every adjastment cell as a frontier, if not done so already
			var testpos = position + maze.directions[dirn]
			if !maze.is_visited(testpos) and frontiers.find(testpos) == -1:
				frontiers.append(testpos)
		
		# If there are no frontiers left - our job here is done
		keepgoing = len(frontiers) > 0
		if keepgoing:
			var rand_i = rng.randi_range(0, len(frontiers)-1)
			var rand_f = frontiers[rand_i]
			frontiers[rand_i] = frontiers[len(frontiers)-1]
			frontiers.pop_back()
			
			# Choosing random 'in' adjastment cell to carve from
			var ins = []
			for dirn in maze.directions_from(rand_f):
				var testpos = rand_f + maze.directions[dirn]
				if maze.is_visited(testpos):
					ins.append(dirn)
			if len(ins) > 0:
				maze.set_open(rand_f, ins[rng.randi_range(0, len(ins)-1)])
			position = rand_f
	
