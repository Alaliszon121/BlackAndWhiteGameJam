class_name Player

extends KinematicBody2D

var velocity = Vector2.ZERO
enum States {WALK}
var state = States.WALK
const ACCELERATION = 500
const SPEED = 300
const FRICTION = 250

var last_position
var rotation_rate = 10.0
# magnitude((last - curr)) / delta
# input: 0..300
# output: 1..10
func _process(delta):
	match state:
		States.WALK:
			walk_state(delta)

func walk_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		var accel = ACCELERATION * delta
		if input_vector.length() > 0.5:
			accel = accel * 2
		velocity = velocity.move_toward(input_vector * SPEED, accel)
		
		#var true_speed = magnitude((last_position - position)) / delta
		
		
		rotation = lerp_angle(rotation, velocity.angle() + PI / 2, 10.0 * get_physics_process_delta_time())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
