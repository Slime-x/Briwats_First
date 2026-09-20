extends Node2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print($LULeg.position.y)
	if $LULeg.position.y > 200:
		global_position = Vector2(20, 20)
