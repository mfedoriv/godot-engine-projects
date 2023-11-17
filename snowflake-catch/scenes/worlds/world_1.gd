extends Node2D

@export var snowflake_scene: PackedScene
@export var icicle_scene: PackedScene

@onready var player = $Player
@onready var combo_tracker = %ComboTracker
@onready var user_interface = $UserInterface
@onready var player_start_position = $PlayerStartPosition
@onready var icicle_spawn_timer = $IcicleSpawnTimer
@onready var spawn_timer = $SpawnTimer
@onready var restart_button = %RestartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	player.connect("player_fallen", _on_player_fallen)
	

func new_game():
	player.start(player_start_position.position)
	spawn_timer.start()
	icicle_spawn_timer.start()
	user_interface.start()



func game_over():
	spawn_timer.stop()
	icicle_spawn_timer.stop()
	user_interface.show_final_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_spawn_timer_timeout():
	var snowflake = snowflake_scene.instantiate()
	snowflake.connect("snowflake_catched", _on_snowflake_catched)
	
	var snowflake_spawn_location = get_node("SnowflakePath/SnowflakeSpawnLocation")
	snowflake_spawn_location.progress_ratio = randf()
	snowflake.position = snowflake_spawn_location.position
	add_child(snowflake)


func _on_snowflake_catched():
	user_interface.increase_snowflake_counter()
	combo_tracker.add_part()


func _on_player_fallen():
	game_over()


func _on_icicle_spawn_timer_timeout():
	print('Spawn Icicle')
	var icicle = icicle_scene.instantiate()
	var icicle_spawn_location = get_node("IciclePath/IcicleSpawnLocation")
	icicle_spawn_location.progress_ratio = randf()
	icicle_spawn_location.position.y = -50
	print('Position: ', icicle_spawn_location.position)
	icicle.position = icicle_spawn_location.position
	add_child(icicle)
	


func _on_restart_button_pressed():
	new_game()
