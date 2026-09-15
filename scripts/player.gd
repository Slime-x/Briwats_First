extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var start_position = Vector2(20,20)
var hooked = false
var hook_position = Vector2.ZERO
var rope_length = 0.0

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if hooked:
			rope_length = max(rope_length - 20 , 20)
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY

	# This aims for the hook 
	var hook_direction = get_global_mouse_position() - global_position
	hook_direction = hook_direction.normalized()
	$hook.target_position = hook_direction * 1000
	
	if not hooked:
		# NOrmal Movement
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# HOOK Pulling when hooked. 
	if hooked:
		var to_hook = hook_position - global_position
		var distance = to_hook.length() #distance between where to hook.
		var rope_dir = to_hook.normalized() #dir = directio btw.
		
		if distance > rope_length:
			global_position = hook_position - rope_dir * rope_length
			
			#To Swing
			var radial_velocity = velocity.dot(rope_dir) * rope_dir
			velocity -= radial_velocity
	
	#Draw Rope
	if hooked:
		$rope.points = PackedVector2Array([
			Vector2.ZERO,
			$rope.to_local(hook_position)
		])
	else:
		$rope.clear_points()
	
	
	# Falls off the map
	if position.y > 1000:
		position = start_position

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		shoot_hook()
	if event.is_action_released("hook"):
		release_hook()
		
func shoot_hook():
	$hook.target_position = (get_global_mouse_position() - global_position).limit_length(1000)
	$hook.force_raycast_update()
	if $hook.is_colliding():
		hooked = true
		hook_position = $hook.get_collision_point()
		rope_length = global_position.distance_to(hook_position)
		
func release_hook():
	hooked = false
	$rope.clear_points()
