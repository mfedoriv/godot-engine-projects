extends CharacterBody2D


@export var MAX_SPEED = 150.0
@export var ACCELERATION = 900
@export var FRICTION = 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_moving(input_axis, delta)

	move_and_slide()


func handle_moving(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
