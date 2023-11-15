extends Node2D

@export var snowflake_scene: PackedScene

@onready var player = $Player
@onready var combo_tracker = $UserInterface/ComboTracker
@onready var user_interface = $UserInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnTimer.start()
	player.connect("player_fallen", _on_player_fallen)
	
	
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
	$SpawnTimer.stop()
	user_interface.show_final_score()
	
