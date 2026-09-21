# Sorry guys i'll have to also retire this code :(
extends Area2D

@export var destination: Area2D
var can_teleport = true

func _on_body_entered(body):
	if not can_teleport:
		return
		print("wrong can teleport")
	
	if body.is_in_group("player"):
		print("the player is called")
	if can_teleport:
			can_teleport = false
			destination.can_teleport = false
			
			body.global_position = destination.global_position
			print(destination.global_position)
			
			await get_tree().create_timer(0.5).timeout
			can_teleport = true
			destination.can_teleport = true
			print("should work?")
			
