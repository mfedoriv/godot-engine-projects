extends Control

@onready var score_label = $ScoreLabel
@onready var final_score_label = $FinalScoreLabel
@onready var combo_tracker = $ComboTracker

var score = 0
var snowflake_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func increase_snowflake_counter():
	snowflake_counter += 1
	score += 1 * combo_tracker.combo
	update_score_label()

func update_score_label():
	score_label.text = str(score)


func show_final_score():
	final_score_label.text = "Final score\n" + str(score)
	final_score_label.visible = true
