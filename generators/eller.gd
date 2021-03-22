# Eller's algorithm
# Detailed description: http://weblog.jamisbuck.org/2010/12/29/maze-generation-eller-s-algorithm

var rng = RandomNumberGenerator.new()

func generate(maze):
	rng.randomize()
	maze.reset_doors()
	
	# Prepairing sets representations
	var sets = []
	var setMap = []
	for i in range(maze.width - 1):
		sets.append({ i: true, "n": 1 })
		setMap.append(i)
	
	for y in range(maze.height - 1):
		for x in range(maze.width - 1):
			# Randomly remove east wall and merging sets
			if (setMap[x] != setMap[x + 1] and rng.randi_range(0, 1) == 1) or y == (maze.height-1):
				maze.set_open(Vector2(x, y), 'E')
				# Merging sets together
				var lIndex = setMap[x]
				var rIndex = setMap[x + 1]
				var lSet = sets[lIndex]
				var rSet = sets[rIndex]
				for i in range(maze.width - 1):
					if setMap[i] != rIndex:
						continue
					lSet[i] = true
					lSet.n = lSet.n + 1
					rSet.erase(rSet[i])
					rSet.n = rSet.n - 1
					setMap[i] = lIndex
		if y != (maze.height - 1):
			# Randomly remove south walls and making sure that at least one cell in each set has no south wall
			for set in sets:
				var opened
				var lastCell
				for x in set.keys():
					if typeof(x) == TYPE_STRING and x == "n":
						continue
					lastCell = x
					if rng.randi_range(0, 1) == 1:
						maze.set_open(Vector2(x, y), 'S')
						opened = true
				if !opened and lastCell:
					maze.set_open(Vector2(lastCell, y), 'S')
			
			# Removing cell with south walls from their sets
			for x in range(maze.width - 1):
				if maze.is_closed(Vector2(x, y), 'S'):
					var set = sets[setMap[x]]
					set.n -= 1
					set.erase(set[x])
					setMap.erase(setMap[x])
			
			# Gathering all empty sets in a list
			var emptySets = []
			for i in range(len(sets)):
				var set = sets[i]
				if set.n == 0:
					emptySets.append(i)
