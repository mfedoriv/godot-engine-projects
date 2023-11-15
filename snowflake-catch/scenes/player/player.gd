extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_2d = $Sprite2D

signal player_fallen

func _physics_process(delta):
	apply_gravity(delta)
	handle_wall_jump()
	handle_jump(true)
	var input_axis = Input.get_axis("left", "right")
	handle_moving(input_axis, delta)
	handle_air_moving(input_axis, delta)
	handle_rotation(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animations(input_axis)
	move_and_slide()
	just_wall_jumped = false # to reset if it was wall_jump


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func handle_jump(can_air_jump=false):
	if is_on_floor(): air_jump = true
	if Input.is_action_just_pressed("jump") and is_on_floor() and !movement_data.is_fallen:
		_jump()
	elif !is_on_floor():
		if Input.is_action_just_released("jump"):
			_jump_cut()
		
		if Input.is_action_just_pressed("jump") and can_air_jump and air_jump and !just_wall_jumped:
			_jump(0.8)
			air_jump = false


func _jump(velocity_scale=1.0):
#	print('Jump Velocity:', movement_data.jump_velocity, 'Velocity Scale:', velocity_scale)
	velocity.y = movement_data.jump_velocity * velocity_scale


func _jump_cut():
	if velocity.y < movement_data.jump_velocity / 4:
		velocity.y = movement_data.jump_velocity / 4


func handle_wall_jump():
	if !is_on_wall_only(): return
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * movement_data.max_speed
		_jump(0.8)
		just_wall_jumped = true
		

func handle_moving(input_axis, delta):
	if !is_on_floor(): return
	if input_axis and !movement_data.is_fallen:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.max_speed, movement_data.acceleration * delta)

func handle_air_moving(input_axis, delta):
	if is_on_floor(): return
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * movement_data.max_speed, movement_data.air_acceleration * delta)

func handle_rotation(input_axis, delta):
	var rotation_force = abs(rotation * movement_data.rotation_scale) if abs(rotation) > 0.2 else 0.3
	if input_axis and !movement_data.is_fallen:
		rotate(deg_to_rad(movement_data.rotation_speed * input_axis * rotation_force))
	if !input_axis and !movement_data.is_fallen:
		rotation = move_toward(rotation, 0, movement_data.rotation_acceleration * delta)
	if abs(rotation_degrees) > 90 and is_on_floor():
		movement_data.is_fallen = true
		emit_signal("player_fallen")


func apply_friction(input_axis, delta):
	if !input_axis and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if !input_axis and !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
		

func update_animations(input_axis):
	if input_axis:
		sprite_2d.flip_h = input_axis > 0
		# run
#	else:
#		# idle
#	if not is_on_floor():
#		# jump
