extends CharacterBody2D


const ACCELERATION = 600
const DEACCELERATION = 300
const MAX_SPEED = 600
const TURN_SPEED = 500
const FRICTION = 100
const TURN_FORCE = 0.5


@onready var push_multiplier_updater: Control = $PushMultiplierUpdater

@onready var push_timer: Timer = $PushTimer
@onready var push_cooldown_timer: Timer = $PushCooldownTimer
@onready var trail_spawner_component: SpawnerComponent = $TrailSpawnerComponent
@onready var left_foot: Marker2D = $LeftFoot
@onready var right_foot: Marker2D = $RightFoot

var is_right: bool = true
var push_multiplier: float = 0
var is_pushing: bool = false
var can_pushing: bool = true


func _ready() -> void:
	push_multiplier_updater.send_push_value.connect(update_push_multiplier)
	push_timer.timeout.connect(disable_is_pushing)
	push_cooldown_timer.timeout.connect(enable_can_pushing)


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	
	handle_pushing(delta)
	handle_moving(direction, delta)
	apply_friction(delta)
	handle_turning(direction)
	handle_breaking(delta)
	
	#print(velocity.y)

	move_and_slide()


func handle_pushing(delta):
	if !is_pushing:
		return
	velocity.y = move_toward(velocity.y, -MAX_SPEED, ACCELERATION * push_multiplier * delta)
	handle_moving(1 if is_right else -1, delta, TURN_FORCE * 2)
	

func handle_moving(direction, delta, turn_force=TURN_FORCE):
	if velocity.y == 0:
		return
	if direction:
		velocity.x = move_toward(velocity.x, TURN_SPEED * direction, turn_force * ACCELERATION * push_multiplier * delta)


func apply_friction(delta):
	if is_pushing:
		return
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.y = move_toward(velocity.y, 0, FRICTION * delta)


func handle_turning(direction):
	if direction > 0:
		is_right = true
	elif direction < 0:
		is_right = false


func handle_breaking(delta):
	if Input.is_action_pressed("break"):
		velocity.y = move_toward(velocity.y, 0, DEACCELERATION * delta)


func change_turning():
	is_right = true if is_right == false else false


func update_push_multiplier(value: float):
	if !can_pushing:
		return
	push_multiplier = value
	draw_skate_trail()
	push_timer.start()
	is_pushing = true
	can_pushing = false
	push_cooldown_timer.start()


func disable_is_pushing():
	change_turning()
	is_pushing = false


func enable_can_pushing():
	can_pushing = true


func draw_skate_trail():
	#trail_spawner_component.spawn(global_position, self)
	if is_right and is_pushing:
		print('Draw right')
		trail_spawner_component.spawn(right_foot.global_position, self)
	elif !is_right and is_pushing:
		print('Draw left')
		trail_spawner_component.spawn(left_foot.global_position, self)
	elif velocity.y < 0:
		print('Draw right and left')
		trail_spawner_component.spawn(right_foot.global_position, self)
		trail_spawner_component.spawn(left_foot.global_position, self)

