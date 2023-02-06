extends Navigation2D

export(float) var character_speed = 100.0
var path = []
const slow_down_distance = 100

onready var character = $Shark

onready var positions = [$Positions/Position2D, $Positions/Position2D2, $Positions/Position2D3, 
$Positions/Position2D4, $Positions/Position2D5]

func fm_curve_uniform_s(alpha):
	var sqt = alpha * alpha
	return sqt / (2.0 * (sqt - alpha) + 1.0)

func _process(delta):
	var pos = character.position
	if path.empty():
		_update_navigation_path(pos, positions[0].position)
		return
		
	var distance_between_points = character.position.distance_to(path[0])
	
	var walk_distance = character_speed * delta
		
	# The position to move to falls between two points.
	if distance_between_points <= slow_down_distance:
		walk_distance = walk_distance * (fm_curve_uniform_s(distance_between_points / slow_down_distance) * 0.8 + 0.2)
	
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
