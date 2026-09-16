extends Area2D


var level = 1

func _on_body_entered(_body):
	call_deferred("next_lvl")
	
func next_lvl():
	get_tree().change_scene_to_file("res://scenes/level_" + str(level) + ".tscn")
	level += 1
