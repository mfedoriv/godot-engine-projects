extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var just_wall_jumped = false
var just_air_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@onready var cat_sprite_2d = $CatSprite2D
@onready var cat_animation_player = $CatAnimationPlayer

const JUMP_SOUNDS = [preload("res://assets/sounds/sfx/jump_1.ogg"),
					preload("res://assets/sounds/sfx/jump_2.ogg"),
					preload("res://assets/sounds/sfx/jump_3.ogg"),
					preload("res://assets/sounds/sfx/jump_4.ogg")]

const FALL_SOUNDS = [preload("res://assets/sounds/sfx/meow_1.ogg"),
					preload("res://assets/sounds/sfx/meow_2.ogg")]
					
signal player_fallen


func _physics_process(delta):
	apply_gravity(delta)
	
	handle_wall_jump()
	handle_jump(true)
	var input_axis = Input.get_axis("left", "right")
	handle_moving(input_axis, delta)
	handle_air_moving(input_axis, delta)
	update_animations(input_axis)
	handle_rotation(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	
	move_and_slide()
	just_wall_jumped = false # to reset if it was wall_jump


func start(pos):
	rotation = 0
	position = pos
	movement_data.is_fallen = false


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
			just_air_jumped = true


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
		fall()


func apply_friction(input_axis, delta):
	if !input_axis and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)


func apply_air_resistance(input_axis, delta):
	if !input_axis and !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
		


func update_animations(input_axis):
	if movement_data.is_fallen: return
	if input_axis:
		cat_sprite_2d.flip_h = input_axis > 0
	if Input.is_action_just_pressed("jump") and !movement_data.is_fallen and air_jump:
		print("Jump Animation")
		cat_animation_player.play("jump")
		SfxHandler.play_random_sfx(JUMP_SOUNDS, 0.3)
	elif !is_on_floor() and Input.is_action_just_pressed("jump") and !just_wall_jumped and just_air_jumped:
		print("Jump Animation")
		cat_animation_player.play("jump")
		SfxHandler.play_random_sfx(JUMP_SOUNDS, 0.3)
		just_air_jumped = false
	elif !cat_animation_player.is_playing():
		print("Idle Animation")
		cat_animation_player.play("idle")
#	if input_axis and is_on_floor():
#		print("Run Animation")
		
#		pixel_sprite_2d.flip_h = input_axis < 0
#		animation_player.play("run")
#		# run
#	elif Input.is_action_just_pressed("jump"):
#		print("Jump Animation")
#		animation_player.play("jump")
#	else:
#		print("Idle Animation")
#		animation_player.play("idle")
#	if not is_on_floor():
#		# jump

func play_catch_animation():
	cat_animation_player.play("catch")

func fall():
	if !movement_data.is_fallen:
		movement_data.is_fallen = true
		emit_signal("player_fallen")
		SfxHandler.play_random_sfx(FALL_SOUNDS, 0.2)
		cat_animation_player.play("fall")


func _on_hazard_detector_area_entered(_sarea):
	fall()
	
