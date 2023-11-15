extends Panel

@export_range(1, 100) var part_size = 200
@export var part_size_decreasing_value_per_combo = 10
@export var decrease_speed = 90

@onready var combo_progress_bar = $Panel/ComboProgressBar

@onready var focus_timer = $FocusTimer
@onready var combo_label = $Panel/ComboLabel

var is_focused : bool = true
var combo = 1

signal combo_up
signal combo_down

func _ready():
	combo_progress_bar.value = 0
	update_combo_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print('Is focused:', is_focused)
	print('Combo:', combo)
	if combo_progress_bar.value < 2 and combo > 1:
		combo_progress_bar.value = combo_progress_bar.max_value
		combo -= 1
		update_combo_label()
	if not is_focused:
		print('Progress Bar Value:', combo_progress_bar.value)
#		print('Progress Bar Decreasing step:', decrease_speed * delta)
		combo_progress_bar.value -= decrease_speed * delta

func add_part():
	var new_value = combo_progress_bar.value + max(part_size / combo, part_size - (combo * 10))
	if new_value >= combo_progress_bar.max_value:
		combo += 1
		update_combo_label()
	combo_progress_bar.value = int(new_value) % int(combo_progress_bar.max_value)
	is_focused = true
	focus_timer.start()

func update_combo_label():
	print('\t\tCombo:', combo)
	combo_label.text = "×" + str(combo)

func _on_focus_timer_timeout():
	is_focused = false
