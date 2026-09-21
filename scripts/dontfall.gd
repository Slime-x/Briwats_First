extends Node2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# print($LULeg.position.y)
	if $LULeg.position.y > 2000:
		reset_ragdoll()

func reset_ragdoll():
	var offset = Vector2(0, -100) - $LULeg.global_position
	
	for child in get_children():
		if child is RigidBody2D:
			# Initialize the stuff
			child.global_position += offset
			child.linear_velocity = Vector2.ZERO
			child.angular_velocity = 0.0
