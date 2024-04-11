extends RigidBody2D

@export var engine_power = 500
@export var spin_power = 4000

var thrust = Vector2.ZERO # тяга
var rotation_dir = 0

func _process(delta):
	get_input()

func get_input():
	thrust = Vector2.ZERO
		
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	
func _physics_process(delta):
	constant_force = thrust
	constant_torque = rotation_dir * spin_power # вращающий момент
