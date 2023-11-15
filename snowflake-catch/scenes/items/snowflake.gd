extends Area2D


@export_range(1, 1000) var frequency = 5
@export_range(0, 1000) var amplitude = 150

signal snowflake_catched

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_parameters()

var falling_speed = 100
var x_shift = 100
var rotate_angle = 1
var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(deg_to_rad(rotate_angle))
	time += delta
	position.y += falling_speed * delta
	var sine_movement = sin(time * frequency) * amplitude
	position.x = position.x + (sine_movement + x_shift) * delta


func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("snowflake_catched")
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func randomize_parameters():
	frequency = randf_range(3, 5)
	amplitude = randi_range(100, 200)
	falling_speed = randi_range(50, 130)
	x_shift = randi_range(-70, 70)
	rotate_angle = randf_range(-1, 1)
	var snowflake_size = randf_range(2, 4)
	scale = Vector2(snowflake_size, snowflake_size)
