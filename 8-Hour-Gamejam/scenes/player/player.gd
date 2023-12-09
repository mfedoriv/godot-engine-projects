extends CharacterBody2D

const ACCELERATION = 1200
const MAX_SPEED = 100
const FRICTION = 1400

@onready var player_animation_player = $PlayerAnimationPlayer
@onready var eye_animation_player = $EyeAnimationPlayer
@onready var light_casting_shadows = $LightCastingShadows
@onready var light_lighting_walls = $LightLightingWalls


func _ready():
	Globals.is_eye_open = false

func _physics_process(delta):
	var input_axis = Input.get_vector("left", "right", "up", "down")
	handle_moving(input_axis, delta)
	apply_friction(input_axis, delta)
	update_player_animations(input_axis)
	update_eye_animations(input_axis)
	handle_eye_switch()
	light_switch(Globals.is_eye_open)
	move_and_slide()


func handle_moving(input_axis, delta):
	input_axis = input_axis.normalized()
	velocity.x = move_toward(velocity.x, input_axis.x * MAX_SPEED, ACCELERATION * delta)
	velocity.y = move_toward(velocity.y, input_axis.y * MAX_SPEED, ACCELERATION * delta)
	
	
func apply_friction(input_axis, delta):
	if !input_axis:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
		
		
func update_player_animations(input_axis):
	if input_axis:
		player_animation_player.play("run")
	else:
		player_animation_player.play("idle")

func update_eye_animations(input_axis):
	if  input_axis and Globals.is_eye_open:
		eye_animation_player.play("eye_open_run")
	elif !input_axis and Globals.is_eye_open:
		eye_animation_player.play("eye_open_idle")
	else:
		eye_animation_player.play("eye_closed_idle")

func handle_eye_switch():
	if Input.is_action_just_pressed("switch_eye"):
		Globals.is_eye_open = !Globals.is_eye_open

func light_switch(enabled):
	light_casting_shadows.enabled = enabled
	light_lighting_walls.enabled = enabled
