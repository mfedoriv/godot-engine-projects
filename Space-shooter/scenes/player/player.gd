extends CharacterBody2D

@export var MAX_SPEED = 500
@export var ACCELERATION = 300
@export var FRICTION = 10
@export var TURN_SPEED = 3

var current_speed = 0

func _physics_process(delta):
	var move_axis = Input.get_axis("move_backward", "move_forward")
	var turn_axis = Input.get_axis("turn_left", "turn_right")

	handle_moving(move_axis, delta)
	handle_turning(turn_axis, delta)

func handle_moving(move_axis, delta):
	if move_axis > 0:
		current_speed = move_toward(current_speed, MAX_SPEED, ACCELERATION * delta)
	elif move_axis < 0:
		current_speed = move_toward(current_speed, -MAX_SPEED, ACCELERATION * delta)
	else:
		current_speed = move_toward(current_speed, 0, FRICTION * delta)
	
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * current_speed
	move_and_slide()

func handle_turning(turn_axis, delta):
	if turn_axis != 0:
		rotation += turn_axis * TURN_SPEED * delta
