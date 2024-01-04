extends Control

const STEP_MULTIPLIER = 6

@onready var progress_bar: ProgressBar = $ProgressBar

signal send_push_value(value)

var value_direction: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_value_direction()
	handle_push_signal()
	update_push(delta)


func update_push(delta):
	# Увеличиваем значение шага приращения в зависимости от текущего значения Progress Bar
	var step = lerp(10, 100, progress_bar.value / progress_bar.max_value)
	if Input.is_action_pressed("push"):
		progress_bar.value += STEP_MULTIPLIER * step * value_direction * delta
	else:
		progress_bar.value = 0


func update_value_direction():
	if progress_bar.value == 0:
		value_direction = 1
	if progress_bar.value == progress_bar.max_value:
		value_direction = -1


func handle_push_signal():
	if Input.is_action_just_released("push"):
		send_push_value.emit(progress_bar.value / 100)



