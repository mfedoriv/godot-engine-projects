extends Control

@onready var final_score_label = %FinalScoreLabel
@onready var score_label = %ScoreLabel
@onready var combo_tracker = %ComboTracker
@onready var restart_button = %RestartButton

var score = 0
var snowflake_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	score = 0
	snowflake_counter = 0
	combo_tracker.start()
	score_label.visible = true
	combo_tracker.visible = true
	restart_button.visible = false
	final_score_label.visible = false
	update_score_label()

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
	score_label.visible = false
	combo_tracker.visible = false
	restart_button.visible = true
	final_score_label.text = "Final score\n" + str(score)
	final_score_label.visible = true
