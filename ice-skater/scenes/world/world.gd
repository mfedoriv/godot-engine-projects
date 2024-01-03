extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_camera_zoom_by_velocity(delta)


func change_camera_zoom_by_velocity(delta):
	var default_zoom = 2
	var min_zoom = 1
	var default_offset = -200
	var max_offset = -400
	
	var step = smoothstep(0.0, 1.0, -player.velocity.y / player.MAX_SPEED)
	var zoom = lerp(default_zoom, min_zoom, step)
	
	
	camera.zoom.y = move_toward(camera.zoom.y, zoom, 0.1 * delta)
	camera.zoom.x = move_toward(camera.zoom.x, zoom, 0.1 * delta)
	
	#var offset = lerp(default_offset, max_offset, step)
	#print(offset)
	#camera.offset.y = move_toward(camera.offset.y, offset, 100 * delta)

