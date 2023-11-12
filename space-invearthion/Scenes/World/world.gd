extends Node2D

@onready var _sun = $Sun
# Called when the node enters the scene tree for the first time.
func _ready():
	_sun.play("move")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
