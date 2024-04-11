extends CharacterBody2D


@export var MAX_SPEED = 150.0
@export var ACCELERATION = 900
@export var FRICTION = 700

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var input_axis = Input.get_axis("move_left", "move_right")
	var input_axis_vertical = Input.get_axis("move_up", "move_down")
	handle_moving(input_axis, delta)
	handle_vertical_moving(input_axis_vertical, delta)

	move_and_slide()


func handle_moving(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


func handle_vertical_moving(input_axis, delta):
	if input_axis:
		velocity.y = move_toward(velocity.y, input_axis * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
