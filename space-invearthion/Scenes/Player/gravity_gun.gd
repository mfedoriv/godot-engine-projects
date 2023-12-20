extends Node2D

var gravity_force = 10 # Сила притяжения грави-пушки
var push_force = 300 # Сила отталкивания грави-пушки
var grab_range = 300 # Диапазон действия грави-пушки
var grabbed_meteor = null # Метеорит, захваченный грави-пушкой

@onready var raycast = $RayCast2D

func _physics_process(delta):
    look_at(get_global_mouse_position())
    rotation += PI/2

    if Input.is_action_pressed('mouse_right'):
        grab_meteor()

    if Input.is_action_just_pressed('mouse_left') and grabbed_meteor != null:
        shoot_meteor()

func grab_meteor():
    raycast.target_position.y = -grab_range
    raycast.force_raycast_update()

    if raycast.is_colliding() and raycast.get_collider().is_in_group("meteor"):
        grabbed_meteor = raycast.get_collider()

    if grabbed_meteor != null:
        var direction_to_meteor = (grabbed_meteor.global_position - global_position).normalized()
        grabbed_meteor.apply_central_impulse(-direction_to_meteor * gravity_force)

func shoot_meteor():
    var direction_to_mouse = (get_global_mouse_position() - global_position).normalized()
    grabbed_meteor.apply_central_impulse(direction_to_mouse * push_force)
    grabbed_meteor = null
