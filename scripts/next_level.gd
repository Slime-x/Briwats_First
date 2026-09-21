extends Area2D


var level

func _on_body_entered(body):
	Gamemanager.level += 1
	level = Gamemanager.level
	# This keeps giving errors and call_deferred() doesn't work either
	get_tree().change_scene_to_file("res://scenes/level_" + str(level) + ".tscn")	

	
func next_lvl():
	get_tree().change_scene_to_file("res://scenes/level_" + str(level) + ".tscn")
	
