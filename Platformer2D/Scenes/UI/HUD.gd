extends CanvasLayer

@onready var diamonds_score = $DiamondsScore

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_score()

func update_score():
	diamonds_score.text = str(Globals.diamonds_score)
