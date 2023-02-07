extends KinematicBody2D

export var path_to_player := NodePath()
export var path_of_positions := NodePath()

var _velocity := Vector2.ZERO
var can_see_player := false
var counter = 2
 
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _timer: Timer = $Timer
onready var _player := get_node(path_to_player)
onready var _positions := get_node(path_of_positions)

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready() -> void:
	_update_pathfinding()
	_timer.connect("timeout", self, "_update_pathfinding")
	animationTree.active = true

func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		counter += 1
		if counter > 3:
			counter = 0
		return
	
	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	#var desired_velocity := direction * _agent.max_speed
	var desired_velocity := direction * 200.0
	
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	
	_velocity = move_and_slide(_velocity)
	$raycast.rotation = _velocity.angle()
	animationTree.set("parameters/Walk/blend_position", _velocity.normalized())
	animationState.travel("Walk")

func _update_pathfinding() -> void:
	#print("update!")
	if !can_see_player:
		_agent.set_target_location(_positions.get_child(counter).position)
		
	else:
		_agent.set_target_location(_player.global_position)
