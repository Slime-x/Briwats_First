extends Node2D

@export var max_grapple_distance := 1000.0
@export var rope_change_speed := 200.0
@export var rope_min_length := 20.0

# How strongly R/F pulls the hand toward the hook
@export var grapple_pull_strength := 15000.0

var hooked := false
var hook_position := Vector2.ZERO
var rope_length := 0.0

@onready var target_body: RigidBody2D = get_parent() as RigidBody2D


func _physics_process(delta: float) -> void:
	if target_body == null:
		return

	# -----------------------------
	# Change rope length
	# -----------------------------
	if hooked and Input.is_action_pressed("ROPE_UP"):
		rope_length = max(
			rope_length - rope_change_speed * delta,
			rope_min_length
		)

	if hooked and Input.is_action_pressed("ROPE_DOWN"):
		rope_length += rope_change_speed * delta


	# -----------------------------
	# Aim the hook at the mouse
	# -----------------------------
	var mouse_local := to_local(get_global_mouse_position())
	$hook.target_position = mouse_local.limit_length(max_grapple_distance)


	# -----------------------------
	# Grapple physics
	# -----------------------------
	if hooked:
		# Hold R or F to pull toward hook
		if Input.is_key_pressed(KEY_R) or Input.is_key_pressed(KEY_F):
			rope_length = max(
				rope_length - rope_change_speed * delta,
				rope_min_length
			)

			pull_toward_hook()

		apply_rope_constraint()


	# -----------------------------
	# Draw rope
	# -----------------------------
	if hooked:
		$rope.points = PackedVector2Array([
			Vector2.ZERO,
			$rope.to_local(hook_position)
		])
	else:
		$rope.clear_points()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		shoot_hook()

	if event.is_action_released("hook"):
		release_hook()


func shoot_hook() -> void:
	var mouse_local := to_local(get_global_mouse_position())
	$hook.target_position = mouse_local.limit_length(max_grapple_distance)

	$hook.force_raycast_update()

	if $hook.is_colliding():
		hooked = true

		hook_position = $hook.get_collision_point()

		# Distance from right hand to hook
		rope_length = target_body.global_position.distance_to(hook_position)


func release_hook() -> void:
	hooked = false
	$rope.clear_points()

	# Give the hand some momentum when released
	target_body.linear_velocity *= 1.5


func pull_toward_hook() -> void:
	var to_hook := hook_position - target_body.global_position
	var distance := to_hook.length()

	if distance <= rope_min_length:
		return

	var direction := to_hook.normalized()

	# Pull the right hand toward the hook
	target_body.apply_central_force(
		direction * grapple_pull_strength
	)


func apply_rope_constraint() -> void:
	var to_hook := hook_position - target_body.global_position
	var distance := to_hook.length()

	if distance <= rope_length:
		return

	var rope_direction := to_hook.normalized()

	# Remove velocity moving directly away from the hook
	var radial_velocity := target_body.linear_velocity.dot(rope_direction)

	if radial_velocity < 0:
		target_body.linear_velocity -= radial_velocity * rope_direction
