extends RigidBody2D

@export var movement_force := 15000.0

func _physics_process(_delta):
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		apply_central_force(Vector2(direction * movement_force, 0))
