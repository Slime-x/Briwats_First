extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func revive():
	print("got called from elsewhere")
	$Sprite2D.set_deferred("visible", true)
	set_process(true)
	set_physics_process(true)

	$CollisionShape2D.set_deferred("disabled", false)
	$Label2.set_deferred("visible", true)

func _on_body_entered(body: Node2D) -> void:
	# This keeps giving errors
	get_tree().change_scene_to_file("res://scenes/level_9.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/level_10.tscn")
