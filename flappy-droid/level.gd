extends Node2D

@export var obstacle_scene: PackedScene
var score
var screen_size = DisplayServer.window_get_size()

func game_over():
	$ObstacleTimer.stop()
	
func new_game():
	score = 0
	$StartTimer.start()
	

func _on_start_timer_timeout():
	$ObstacleTimer.start()


func _on_obstacle_timer_timeout():
	print("Timer Timeout", screen_size.x) 
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = Vector2(screen_size.x, randi_range(screen_size.y / 5, 4 * screen_size.y / 5))
	
	add_child(obstacle)
	
func _ready():
	new_game() 
