extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cpu_particles: CPUParticles2D = $CPUParticles2D

@export var rotate_clockwise = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(enable_particles)
	body_exited.connect(disable_particles)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	sprite_2d.flip_h = rotate_clockwise
	cpu_particles.position.x = 13 if rotate_clockwise else -13

func enable_particles(body: Node) -> void:
	print("Body entered:", body.name)
	cpu_particles.emitting = true

func disable_particles(body: Node) -> void:
	print("Body exited:", body.name)
	cpu_particles.emitting = false
