extends CharacterBody2D

@export var MAX_SPEED = 500
@export var ACCELERATION = 300
@export var FRICTION = 200
@export var TURN_SPEED = 3

var current_speed = 0

func _physics_process(delta):
	var move_axis = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var turn_axis = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")

	handle_moving(move_axis, delta)
	handle_turning(turn_axis, delta)

func handle_moving(move_axis, delta):
	if move_axis > 0:
		# Движение вперед
		current_speed = move_toward(current_speed, MAX_SPEED, ACCELERATION * delta)
	elif move_axis < 0:
		# Торможение и движение назад
		current_speed = move_toward(current_speed, -MAX_SPEED, ACCELERATION * delta)
	else:
		# Торможение
		current_speed = move_toward(current_speed, 0, FRICTION * delta)
	
	# Применение скорости к кораблю с учетом направления поворота
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * current_speed
	move_and_slide()

func handle_turning(turn_axis, delta):
	if turn_axis != 0:
		# Поворот
		rotation += turn_axis * TURN_SPEED * delta
