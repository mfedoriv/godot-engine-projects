extends MarginContainer

@onready var start_game_button = %StartGameButton
@onready var quit_game_button = %QuitGameButton


# Called when the node enters the scene tree for the first time.
func _ready():
	start_game_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/worlds/world_1.tscn")


func _on_quit_game_button_pressed():
	get_tree().quit()
