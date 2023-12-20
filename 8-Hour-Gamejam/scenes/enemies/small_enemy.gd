extends CharacterBody2D

const ACCELERATION = 1000
const MAX_SPEED = 50
const FRICTION = 1400

const PIXELS_TO_STOP = 10

@export var target: Node2D

@onready var navigation_agent = $NavigationAgent2D
@onready var follow_path_timer = $FollowPathTimer
@onready var animation_player = $AnimationPlayer
@onready var light = $Light
@onready var sprite_2d = $Sprite2D

var is_following_player = false

func _physics_process(delta):
	var direction_axis = to_local(navigation_agent.get_next_path_position()).normalized()
	handle_moving(direction_axis, delta)
	apply_friction(direction_axis, delta)
	update_animations(direction_axis)
	update_animations_direction(direction_axis)
	move_and_slide()
	

func handle_moving(input_axis, delta):
	input_axis = input_axis.normalized()
	velocity.x = move_toward(velocity.x, input_axis.x * MAX_SPEED, ACCELERATION * delta)
	velocity.y = move_toward(velocity.y, input_axis.y * MAX_SPEED, ACCELERATION * delta)

func apply_friction(input_axis, delta):
	if !input_axis:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)

func update_animations(input_axis):
	update_light()
	if velocity.length() > 0:
		animation_player.play('run')
	else:
		animation_player.play("idle")

func update_animations_direction(input_axis):
	if input_axis.x < 0:
		sprite_2d.flip_h = true
		sprite_2d.position.x = -54
	else:
		sprite_2d.flip_h = false
		sprite_2d.position.x = 0

func update_light():
	light.visible = is_following_player

func create_follow_path():
	#if position.is_equal_approx(target.position):
		#return
	#if not is_following_player:
		#return
	print('Follow')
	navigation_agent.target_position = target.global_position


func _on_update_path_timer_timeout():
	create_follow_path()


func _on_player_detect_area_area_entered(area):
	print('Detected')
	is_following_player = true
	follow_path_timer.start()
	create_follow_path()
	
	
func _on_player_detect_area_area_exited(area):
	is_following_player = false
	follow_path_timer.stop()

