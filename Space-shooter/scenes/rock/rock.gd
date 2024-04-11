extends RigidBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var explosion: Node2D = $Explosion

signal exploded

var screensize = Vector2.ZERO
var pos = Vector2.ZERO
var vel = Vector2.ZERO
var size := 1

var radius
var scale_factor = 0.2

func _ready() -> void:
	start()

func start(_position=pos, _velocity=vel, _size=size):
	position = pos
	size = _size
	mass = 1.5 * size
	sprite.scale = Vector2.ONE * scale_factor * size
	radius = int(sprite.texture.get_size().x / 2 * scale_factor * size)
	var shape = CircleShape2D.new()
	shape.radius = radius
	collision_shape.shape = shape
	linear_velocity = _velocity
	angular_velocity = randf_range(-PI, PI)
	explosion.scale = Vector2.ONE * 0.2 * size
	

func _integrate_forces(physics_state):
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0 - radius, screensize.x + radius)
	xform.origin.y = wrapf(xform.origin.y, 0 - radius, screensize.y + radius)
	physics_state.transform = xform


func explode():
	collision_shape.set_deferred("disabled", true)
	sprite.hide()
	explosion.animation_player.play("explosion")
	$Explosion.show()
	exploded.emit(size, radius, position, linear_velocity)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	await explosion.animation_player.animation_finished
	queue_free()
