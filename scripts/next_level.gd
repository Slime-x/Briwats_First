extends Area2D


var level

func _on_body_entered(body):
	body.level += 1
	call_deferred("next_lvl")
	level = body.level
	
func next_lvl():
	get_tree().change_scene_to_file("res://scenes/level_" + str(level) + ".tscn")
	
