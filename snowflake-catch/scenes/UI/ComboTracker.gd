extends MarginContainer

@export_range(50, 300) var part_size = 200
@export var part_size_decreasing_value_per_combo = 18
@export var decrease_speed = 90

@onready var combo_progress_bar = $Panel/ComboProgressBar

@onready var focus_timer = $FocusTimer
@onready var combo_label = $Panel/ComboLabel
@onready var particles_emitting_timer = $ParticlesEmittingTimer
@onready var combo_particles = $Panel/ComboParticles
@onready var animation_player = $Panel/AnimationPlayer

const COMBO_UP_SOUND = preload("res://assets/sounds/sfx/combo_up.ogg")
const COMBO_DOWN_SOUNDS = [preload("res://assets/sounds/sfx/combo_down.ogg")]

var is_focused : bool = true
var combo = 1

signal combo_up
signal combo_down

func _ready():
	start()


func start():
	combo_progress_bar.value = 0
	combo = 1
	update_combo_label()
	animation_player.play("ComboUp")
	particles_emitting_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print('Is focused:', is_focused)
#	print('Combo:', combo)
	if combo_progress_bar.value < 1 and combo > 1:
		combo_progress_bar.value = combo_progress_bar.max_value
		combo -= 1
		update_combo_label()
		animation_player.play("ComboDown")
		SfxHandler.play_random_sfx(COMBO_DOWN_SOUNDS, 0.5, Vector2(1, 1))
	if not is_focused:
#		print('Progress Bar Value:', combo_progress_bar.value)
#		print('Progress Bar Decreasing step:', decrease_speed * delta)
		combo_progress_bar.value -= decrease_speed * delta
	particles_emmiting()
		
		

func add_part():
	var new_value = combo_progress_bar.value + max(part_size / combo, part_size - (combo * part_size_decreasing_value_per_combo))
	if new_value >= combo_progress_bar.max_value:
		combo += 1
		update_combo_label()
		combo_label.rotation = 0
		animation_player.play("ComboUp")
		SfxHandler.play_sfx(COMBO_UP_SOUND, 0.5)
		particles_emitting_timer.start()
	combo_progress_bar.value = int(new_value) % int(combo_progress_bar.max_value)
	is_focused = true
	focus_timer.start()

func particles_emmiting():
	combo_particles.emitting = not particles_emitting_timer.is_stopped()
	


func update_combo_label():
	print('\t\tCombo:', combo)
	combo_label.text = "×" + str(combo)

func _on_focus_timer_timeout():
	is_focused = false
