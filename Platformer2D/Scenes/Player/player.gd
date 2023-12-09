extends CharacterBody2D


const SPEED = 250.0
const ACCELERATION = 1250.0
const FRICTION = 1600.0
const AIR_RESISTANCE = 500
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var direction = Input.get_axis("left", "right")
	handle_moving(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(direction, delta)
	update_animations(direction)
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif not is_on_floor():
		if Input.is_action_just_released("jump"):
			if velocity.y < JUMP_VELOCITY / 4:
				velocity.y = JUMP_VELOCITY / 4


func handle_moving(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)


func apply_friction(direction, delta):
	if not direction and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_air_resistance(direction, delta):
	if not direction and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)
		

func update_animations(direction):
	if direction != 0:
		#if direction < 0:
			#animated_sprite_2d.flip_h = true
			#
		#else:
			#animated_sprite_2d.flip_h = false
		#animated_sprite_2d.flip_h = (direction < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
