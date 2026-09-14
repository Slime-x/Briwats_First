extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var start_position = Vector2(20,20)
var hooked = false
var hook_position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = get_global_mouse_position() - global_position
	direction = direction.normalized()
	$hook.target_position = direction * 1000
	
	
	# Falls off the map
	if position.y > 1000:
		position = start_position

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		pass
	if event.is_action_released("hook"):
		pass
		
func shoot_hook():
	$hook.target_position = (get_global_mouse_position() - global_position).limit_length(1000)
	$hook.force_raycast_update()
	
	if $hook.is_colliding():
		hooked = true
		hook_position = $hook.get_collision_point()
func release_hook():
	hooked = false
	$rope.clear_points()
