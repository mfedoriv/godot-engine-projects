extends CharacterBody2D

const ACCELERATION = 700
const MAX_SPEED = 400
const FRICTION = 600

const ROTATION_SPEED = 3
const ROTATION_ACCELERATION = 2

const JUMP_VELOCITY = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_fallen = false
var snowflakes_counter = 0

@onready var snow_particles = $SnowParticles

signal player_fallen

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_fallen:
		jump()
		
	if Input.is_action_just_released("jump"):
		jump_cut()

	var direction = Input.get_axis("left", "right")
	var rotation_force = abs(rotation * 1.7) if abs(rotation) > 0.2 else 0.3
	if direction and !is_fallen:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		rotate(deg_to_rad(ROTATION_SPEED * direction * rotation_force))
	elif abs(velocity.x) > 0:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if !direction and !is_fallen:
#			rotation = move_toward(rotation, 0, 0.07)
		rotation = move_toward(rotation, 0, ROTATION_ACCELERATION * delta)
	if abs(rotation_degrees) > 90 and is_on_floor():
		is_fallen = true
		emit_signal("player_fallen")

	move_and_slide()
	

func jump():
	velocity.y = -JUMP_VELOCITY
	
func jump_cut():
	if velocity.y < -(JUMP_VELOCITY / 4):
		velocity.y = -(JUMP_VELOCITY / 4)

func catch_snowflake():
	snowflakes_counter += 1

