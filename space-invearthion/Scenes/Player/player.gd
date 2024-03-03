extends CharacterBody2D

const ACCELERATION = 700
const MAX_SPEED = 80
const FRICTION = 700


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var gravity_gun = $Gravity_gun
@onready var viewport_size = Vector2(get_tree().root.content_scale_size)
@onready var center = viewport_size / 2 + Vector2(0, 5) # Координаты центра окружности
@onready var radius = viewport_size.y / 2 - 20 # Радиус окружности
var speed = 450 # Скорость передвижения
var acceleration = 2700 # Ускорение
var friction = 2700 # Сопротивление





func _physics_process(delta):
    var direction = Input.get_axis("right", "left")

    if direction:
        velocity.x += sign(direction) * acceleration * delta
    else:
        var new_speed = max(abs(velocity.x) - friction * delta, 0)
        velocity.x = sign(velocity.x) * new_speed

    if abs(velocity.x) < 0.01: # Если скорость достаточно мала, установить ее в ноль
        velocity.x = 0

    if abs(velocity.x) > speed:
        velocity.x = sign(velocity.x) * speed

    var angle_change = velocity.x * delta / radius
    var current_angle = (global_position - center).angle()
    var new_angle = current_angle + angle_change
    global_position = center + Vector2(cos(new_angle), sin(new_angle)) * radius

    rotation = new_angle + PI * 1.5
    
    update_animations(direction)

func update_animations(direction):
    if direction == 0:
        ap.play("idle")
    else:
        ap.play("run")
    if direction != 0:
        sprite.flip_h = direction == 1
        
    
