extends KinematicBody2D

export var path_to_player := NodePath()
export var path_of_positions := NodePath()

var _velocity := Vector2.ZERO
var can_see_player := true
var counter = 0
var counter2 = 1
 
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _timer: Timer = $Timer
onready var _player := get_node(path_to_player)
onready var _positions := get_node(path_of_positions)
onready var _raycasts := [$raycast/RayCast2D]

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready() -> void:
	_timer.connect("timeout", self, "_update_pathfinding")
	_agent.connect("velocity_computed", self, "move")
	animationTree.active = true

func _physics_process(delta: float) -> void:
	for _raycast in _raycasts:
		if(_raycast.get_collider() is Area2D):
			print("i see you!")
		else:
			print(_raycast.get_collider())
	
	if _agent.is_navigation_finished():
		counter += 1
		if counter > 3:
			counter = 0
		return
	
	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	#var desired_velocity := direction * _agent.max_speed
	var desired_velocity := direction * _agent.max_speed
	
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)

func move(velocity: Vector2) -> void:
	_velocity = move_and_slide(velocity)
	$raycast.rotation = lerp_angle($raycast.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())
	animationTree.set("parameters/Walk/blend_position", _velocity.normalized())
	animationState.travel("Walk")

func _update_pathfinding() -> void:
	#print("update!")
	if !can_see_player:
		_agent.set_target_location(_positions.get_child(counter).position)
	else:
		_agent.set_target_location(_player.global_position)
