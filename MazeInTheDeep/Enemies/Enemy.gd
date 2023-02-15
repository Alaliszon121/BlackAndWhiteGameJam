extends KinematicBody2D

export var path_to_player := NodePath()
export var path_of_positions := NodePath()

var _velocity := Vector2.ZERO

var can_see_player := false
var raycast_is_colliding := false
var lost_track := false
var target_in_view := false

var counter = 0
var counter2 = 1
 
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _timer: Timer = $Timer
onready var _hunt_timer: Timer = $HuntTimer
onready var _player := get_node(path_to_player)
onready var _positions := get_node(path_of_positions)
onready var _raycasts := [$raycast/RayCast2D, $raycast/RayCast2D2, $raycast/RayCast2D3, $raycast/RayCast2D4, $raycast/RayCast2D5, $raycast/RayCast2D6, $raycast/RayCast2D7]
onready var _animatedSprite := $AnimatedSprite
onready var _fieldOfView := $FieldOfView

func _ready() -> void:
	_timer.connect("timeout", self, "_update_pathfinding")
	_hunt_timer.connect("timeout", self, "_on_HuntTimer_timeout")
	_agent.connect("velocity_computed", self, "move")
	_fieldOfView.connect("target_enter", self, "_on_FieldOfView_target_enter")
	_fieldOfView.connect("target_exit", self, "_on_FieldOfView_target_exit")
	$AudioStreamPlayer2D.play()

func _physics_process(delta: float) -> void:
	check_raycasts_collision()
	
	if _agent.is_navigation_finished():
		counter += 1
		if counter >= 4:
			counter = 0
		return
	
	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)

func check_raycasts_collision() -> void:
	raycast_is_colliding = false
	for _raycast in _raycasts:
		if(_raycast.get_collider() is Chase_area):
			raycast_is_colliding = true
	if raycast_is_colliding:
		can_see_player = true
		lost_track = false
		_hunt_timer.start()
	elif !raycast_is_colliding and lost_track:
		can_see_player = false

func move(velocity: Vector2) -> void:
	_velocity = move_and_slide(velocity)
	_animatedSprite.play("up")
	rotation = lerp_angle(rotation, _velocity.angle() + PI / 2, 5.0 * get_physics_process_delta_time())
	#$raycast.rotation = lerp_angle($raycast.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())

func _update_pathfinding() -> void:
	if can_see_player:
		_agent.set_target_location(_player.global_position)
	else:
		_agent.set_target_location(_positions.get_child(counter).position)

func _on_HuntTimer_timeout():
	lost_track = true

func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
