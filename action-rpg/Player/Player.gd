extends CharacterBody2D

const ACCELERATION = 700
const MAX_SPEED = 80
const FRICTION = 700

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	animation_tree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		# setting input_vector here so player can't change direction during attack
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
