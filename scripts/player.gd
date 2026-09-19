extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var start_position = Vector2(20,20)
var hooked = false
var hook_position = Vector2.ZERO
var hook_object: Node2D = null
var hooked_local_position = Vector2.ZERO
var rope_length = 0.0
var activating_trampolines = []

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	
	#UNCOMMENT THIS AND COMMENT THE _input function and play the game...
	#if Input.is_action_just_pressed("hook"):
		#shoot_hook()
	
	#if you press jump while hooked then it unhooks..
	#if Input.is_action_just_pressed("jump") and hooked:
		#release_hook()
		
	# this is for rope pull. Change the minimum length of rope after making player sprite...
	if hooked and Input.is_action_pressed("ROPE_UP"):
		rope_length = max(rope_length - 50 * delta , 20)
	if hooked and Input.is_action_pressed("ROPE_DOWN"):
		rope_length = max(rope_length + 50 * delta , 20)
	
	# To create momentum while hooked.
	if hooked:
		var direction := Input.get_axis("move_left", "move_right")
		if Input.is_action_pressed("move_left"):
			velocity.x += direction * 2 #Can change (2) for faster or slower momentum.
		if Input.is_action_pressed("move_right"):
			velocity.x += direction * 2

	# This aims for the hook.. Even i am not sure how this worked.. LOL
	var hook_direction = get_global_mouse_position() - global_position
	hook_direction = hook_direction.normalized()
	$hook.target_position = hook_direction * 1000
	
	# NOrmal Movement
	if not hooked:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	# move towards hook position when hooked. 
	if hooked:
		var to_hook = hook_position - global_position
		var distance = to_hook.length() #distance between where to hook.
		var rope_dir = to_hook.normalized() #dir = directio btw.
		
		if distance > rope_length:
			global_position = hook_position - rope_dir * rope_length
			
			#To Swing
			var radial_velocity = velocity.dot(rope_dir) * rope_dir
			velocity -= radial_velocity
	
	#Draw Rope.. color is changable in node btw. 
	if hooked:
		$rope.points = PackedVector2Array([
			Vector2.ZERO,
			$rope.to_local(hook_position)
		])
	else:
		$rope.clear_points()
	
	
	# Falls off the map
	if position.y > 2000:
		position = start_position

	move_and_slide()
	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision == null:
			continue
		
		var collider = collision.get_collider()
		
		if collider == null:
			continue
		
		if collider is TileMapLayer:
			var local = collider.to_local(collision.get_position())
			var coords = collider.local_to_map(local)
			var data = collider.get_cell_tile_data(coords)
			if data and data.get_custom_data("is_spike"):
				die()
			if data and data.get_custom_data("is_trampoline"):
				if not coords in activating_trampolines:
					activating_trampolines.append(coords)
					velocity.y = -1000
					activate_trampoline(collider, coords)

func activate_trampoline(collider: TileMapLayer, coords: Vector2i):
	var original_tile = collider.get_cell_atlas_coords(coords)
	var source_id = collider.get_cell_source_id(coords)

	# Change trampoline to pressed texture
	collider.set_cell(coords, source_id, Vector2i(8, 5))

	# Wait 0.2 seconds
	await get_tree().create_timer(0.2).timeout

	# Change trampoline back to original texture
	collider.set_cell(coords, source_id, original_tile)

	# Allow trampoline to be activated again
	activating_trampolines.erase(coords)


#Comment this whole program. 88-92 all. 
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
		hook_object = $hook.get_collider()
		hooked_local_position = hook_object.to_local($hook.get_collision_point())
		hook_position = hook_object.to_global(hooked_local_position)
		rope_length = global_position.distance_to(hook_position)
		
func release_hook():
	hooked = false
	velocity *= 1.5 #Change this if you feel velocity increases too much after unhooking. I feel like 1.5 is good but 2 is better while testing. 
	$rope.clear_points()
	
func die():
	release_hook()
	position = start_position
	
