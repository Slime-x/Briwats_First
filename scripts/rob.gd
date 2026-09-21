extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_rigid_body_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	
func revive():
	print("revive functional called")
	$Sprite2D.set_deferred("visible", true)
	set_process(true)
	set_physics_process(true)

	$CollisionShape2D.set_deferred("disabled", false)
