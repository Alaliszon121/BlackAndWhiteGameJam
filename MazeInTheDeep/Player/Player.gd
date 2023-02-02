extends KinematicBody2D

var velocity = Vector2.ZERO
enum States {WALK}
var state = States.WALK
const ACCELERATION = 500
const SPEED = 80
const FRICTION = 50

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		States.WALK:
			walk_state(delta)

func idle_state(delta):
	pass

func walk_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		
		animationState.travel("Walk")
		
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
