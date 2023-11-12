extends Node2D

@export var snowflake_scene: PackedScene

@onready var player = $Player
@onready var final_score_label = $UserInterface/FinalScoreLabel

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
	print(snowflake_spawn_location)
	snowflake_spawn_location.progress_ratio = randf()
	snowflake.position = snowflake_spawn_location.position
	
	add_child(snowflake)


func _on_snowflake_catched():
	$UserInterface/ScoreLabel.text = str($Player.snowflakes_counter)
	

func _on_player_fallen():
	$SpawnTimer.stop()
	final_score_label.text = "Final score\n" + str($Player.snowflakes_counter)
	final_score_label.visible = true
	
