extends CharacterBody2D

const ACCELERATION = 700
const MAX_SPEED = 80
const FRICTION = 700


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#var time = 0.0
#var speed = 10
#var radius = 50
#
#@onready var sprite = $AnimatedSprite2D

#func _physics_process(delta):
#	time += delta
#	var angle = speed * time
#	var rotation = Vector2(cos(angle), sin(angle))
#	sprite.position = rotation * distance_from_center

#func _physics_process(delta):
#
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var a = 2 * asin(speed * delta / (2 * radius))
#	rotation -= a
#	move_and_collide(transform.x * speed * delta)
#	#var direction = Input.get_axis("ui_left", "ui_right")
#	#if direction:
#	#	velocity.x = direction * SPEED
#	#else:
#	#	velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	#move_and_slide()

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var gravity_gun = $Gravity_gun

var speed = 150 # Скорость передвижения
var acceleration = 900 # Ускорение
var friction = 900 # Сопротивление
var radius = 158 # Радиус окружности

var center = Vector2(320, 180) # Координаты центра окружности

func _physics_process(delta):
	var direction = Input.get_axis("right", "left")

	if direction:
		velocity.x += sign(direction) * acceleration * delta
	else:
		var new_speed = max(abs(velocity.x) - friction * delta, 0)
		velocity.x = sign(velocity.x) * new_speed

	if abs(velocity.x) < 0.01: # Если скорость достаточно мала, установить ее в ноль
		velocity.x = 0

	if abs(velocity.x) > speed:
		velocity.x = sign(velocity.x) * speed

	var angle_change = velocity.x * delta / radius
	var current_angle = (global_position - center).angle()
	var new_angle = current_angle + angle_change
	global_position = center + Vector2(cos(new_angle), sin(new_angle)) * radius

	rotation = new_angle + PI * 1.5
	
	# animations
	if direction != 0:
		sprite.flip_h = direction == 1
		
	update_animations(direction)

func update_animations(direction):
	if direction == 0:
		ap.play("idle")
	else:
		ap.play("run")
		
	
