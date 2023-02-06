extends Navigation2D

export(float) var character_speed = 300.0
var path = []

onready var character = $Shark

onready var positions = [$Positions/Position2D, $Positions/Position2D2, $Positions/Position2D3, 
$Positions/Position2D4, $Positions/Position2D5, $Positions/Position2D6, 
$Positions/Position2D7, $Positions/Position2D8]

func _process(delta):
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)

func move_along_path(distance):
	var last_point = character.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	character.position = last_point
	set_process(false)
	positions.shuffle()
	_update_navigation_path(character.position, positions[0].position)

func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)
