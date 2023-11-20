extends Node2D

@export var snowflake_scene: PackedScene
@export var icicle_scene: PackedScene

@onready var player = $Player
@onready var combo_tracker = %ComboTracker
@onready var user_interface = %UserInterface

@onready var player_start_position = $PlayerStartPosition
@onready var icicle_spawn_timer = $IcicleSpawnTimer
@onready var spawn_timer = $SpawnTimer
@onready var restart_button = %RestartButton
@onready var parallax_background = $ParallaxBackground
@onready var music_player = $MusicPlayer
@onready var wind_player = $WindPlayer

var parallax_speed = 0.15

const CATCH_SOUNDS = [preload("res://assets/sounds/sfx/catch_1.ogg"),
					preload("res://assets/sounds/sfx/catch_2.ogg"),
					preload("res://assets/sounds/sfx/catch_3.ogg"),
					preload("res://assets/sounds/sfx/catch_4.ogg")]


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	player.connect("player_fallen", _on_player_fallen)
	music_player.play()
	wind_player.play()
	
	

func new_game():
	GameValues.reset_values()
	player.start(player_start_position.position)
	spawn_timer.start()
	icicle_spawn_timer.start()
	user_interface.start()



func game_over():
	GameValues.time = 0
	print("GAME OVER")
	spawn_timer.stop()
	icicle_spawn_timer.stop()
	user_interface.show_final_score()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_parallax_background()

func move_parallax_background():
	# Получаем экранные координаты игрока
	var player_screen_position = player.global_position
	
	# Рассчитываем смещение для каждого фонового слоя на основе экранных координат игрока
	var offset1 = -player_screen_position.x * parallax_speed
	var offset2 = -player_screen_position.x * (parallax_speed * 0.5)
	var offset3 = -player_screen_position.x * (parallax_speed * 0.3)

	# Применяем смещение к позициям фоновых слоев
	$"ParallaxBackground/ParallaxLayer-1".set_motion_offset(Vector2(offset1, 0))
	$"ParallaxBackground/ParallaxLayer-2".set_motion_offset(Vector2(offset2, 0))
	$"ParallaxBackground/ParallaxLayer-3".set_motion_offset(Vector2(offset3, 0))

func _on_spawn_timer_timeout():
	var snowflake = snowflake_scene.instantiate()
	snowflake.connect("snowflake_catched", _on_snowflake_catched)
	
	var snowflake_spawn_location = get_node("SnowflakePath/SnowflakeSpawnLocation")
	snowflake_spawn_location.progress_ratio = randf()
	snowflake.position = snowflake_spawn_location.position
	add_child(snowflake)


func _on_snowflake_catched():
	player.play_catch_animation()
	user_interface.increase_snowflake_counter()
	combo_tracker.add_part()
	SfxHandler.play_random_sfx(CATCH_SOUNDS, 0.5)


func _on_player_fallen():
	game_over()


func _on_icicle_spawn_timer_timeout():
	
	var spawn_time_base = max(1, GameValues.icicle_spawn_time - GameValues.time / 70)
	var spawn_time = randf_range(spawn_time_base - 1, spawn_time_base + 1)
	print("Icicle Spawn Time: ", spawn_time)
	icicle_spawn_timer.wait_time = spawn_time
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


func _on_one_second_timer_timeout():
	print("Time: ", GameValues.time)
	GameValues.time += 1
