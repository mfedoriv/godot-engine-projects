extends Node2D

@onready var gravity_area: Area2D = $GravityArea
@onready var grab_area: Area2D = $GrabArea
@onready var disable_grab_timer: Timer = $GrabArea/DisableGrabTimer
@onready var effects_animation_player: AnimationPlayer = $EffectsAnimationPlayer
@onready var pull_particles_2d: GPUParticles2D = $PullParticles2D

const PULL_FORCE = 980
const PUSH_FORCE = 50000
const GRAB_FORCE = 5000
const WAKEUP_FORCE = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    look_at(get_global_mouse_position())
    var direction = (get_global_position() - get_global_mouse_position()).normalized()
    rotate_gravity(direction)
    wake_up_rigid_body(direction)
    
    if Input.is_action_pressed('mouse_right'):
        pull_object()
    elif Input.is_action_just_pressed('mouse_left'):
        push_object()
    else:
        reset_gravity()
    
    update_animations(direction)
    

func rotate_gravity(direction):
    gravity_area.gravity_direction = direction

func wake_up_rigid_body(direction):
    # Применение небольшой силы ко всем объектам RigidBody2D в области
    for body in gravity_area.get_overlapping_bodies():
        if body is RigidBody2D and body.is_in_group("Grabbable"):
            # Применение небольшой силы WAKEUP_FORCE
            body.apply_central_impulse(direction * WAKEUP_FORCE)


func pull_object():
    #print('PULL')
    gravity_area.gravity = PULL_FORCE


func push_object():
    #print('PUSH')
    disable_grab_force()
    gravity_area.gravity = -PUSH_FORCE


func reset_gravity():
    #print('RESET')
    gravity_area.gravity = 0


func disable_grab_force():
    grab_area.gravity = 0
    disable_grab_timer.start()


func _on_disable_grab_timer_timeout() -> void:
    grab_area.gravity = GRAB_FORCE


func update_animations(direction):
    if Input.is_action_pressed('mouse_right'):
        effects_animation_player.play("pull_object")
        #print(direction.angle())
        #pull_particles_2d.rotation = rad_to_deg(direction.angle())
        #pull_particles_2d.emitting = true
    else:
        effects_animation_player.play("RESET")
        #pull_particles_2d.emitting = false
