extends Node2D

@onready var rock_spawn: PathFollow2D = $RockPath/RockSpawn
@onready var player: RigidBody2D = $PlayerRigidBody

@export var rock_scene : PackedScene

var screensize = Vector2.ZERO
var level = 0
var score = 0
var playing = false

func _ready():
	#randomize()
	screensize = get_viewport().get_visible_rect().size
	for i in range(3):
		spawn_rock(7)
		

func spawn_rock(size, pos=null, vel=null):
	if pos == null:
		rock_spawn.progress = randi()
		pos = rock_spawn.position
	if vel == null:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rock_scene.instantiate()
	r.screensize = screensize
	r.pos = pos
	r.vel = vel
	r.size = size
	call_deferred("add_child", r)
	r.exploded.connect(self._on_rock_exploded)


func _on_rock_exploded(size, radius, pos, vel):
	if size <= 3:
		return
	for offset in [-1, 1]:
		var dir = player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_rock(size - 2, newpos, newvel)
