extends RigidBody2D

@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var muzzle: Marker2D = $Muzzle
@onready var gun_cooldown_timer: Timer = $GunCooldownTimer
@onready var engine_fire: CPUParticles2D = $EngineFire

@export var bullet_scene : PackedScene
@export var engine_power = 500
@export var spin_power = 4000
@export var fire_rate = 0.25

enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = INIT
var thrust = Vector2.ZERO # тяга
var rotation_dir = 0
var can_shoot = true

var screensize = Vector2.ZERO


func _ready() -> void:
	change_state(ALIVE)
	screensize = get_viewport_rect().size # for screen wrap
	gun_cooldown_timer.wait_time = fire_rate
	gun_cooldown_timer.timeout.connect(_on_gun_cooldown_timer_timeout)
	

func _process(delta):
	get_input()
	display_engine_fire()
	
func get_input():
	thrust = Vector2.ZERO
	if state in [DEAD, INIT]:
		return
		
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		

func shoot():
	if state == INVULNERABLE:
		return
	can_shoot = false
	gun_cooldown_timer.start()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(muzzle.global_transform)


func _on_gun_cooldown_timer_timeout():
	can_shoot = true


func _physics_process(delta):
	constant_force = thrust
	constant_torque = rotation_dir * spin_power # вращающий момент


func display_engine_fire():
	engine_fire.emitting = Input.is_action_pressed("thrust")


func change_state(new_state):
	match new_state:
		INIT:
			collision_polygon.set_deferred("disabled", true)
		ALIVE:
			collision_polygon.set_deferred("disabled", false)
		INVULNERABLE:
			collision_polygon.set_deferred("disabled", true)
		DEAD:
			collision_polygon.set_deferred("disabled", true)
	state = new_state


func _integrate_forces(physics_state):
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	physics_state.transform = xform
