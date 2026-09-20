extends CanvasLayer

@onready var startscreen: Control = $startscreen
@onready var choose_level: Control = $choose_level
var level_menu = false
var level

func _ready():
	for button in get_tree().get_nodes_in_group("buttons"):
		button.focus_mode = Control.FOCUS_NONE


func _on_button_pressed(): #StartScreen Play button
	Gamemanager.start_screen = false
	Gamemanager.level_selection = true
	startscreen.hide()
	level_choice()
	level_available()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("menu"):
		level_choice()
		print("Menu open")


func level_available():
	var i = 1

	while i <= Gamemanager.level:
		var level__ = get_node("choose_level/level_" + str(i))
		level__.show()
		i += 1
	
		
func level_choice():
	if level_menu:
		choose_level.hide()
		level_menu = false
	else:
		level_menu = true
		choose_level.show()
		
func next_lvl():
	get_tree().change_scene_to_file("res://scenes/level_" + str(level) + ".tscn")


func _on_level_1_pressed() -> void:
	level = 1
	call_deferred("next_lvl")


func _on_level_2_pressed() -> void:
	level = 2
	call_deferred("next_lvl")


func _on_level_3_pressed() -> void:
	level = 3
	call_deferred("next_lvl")


func _on_level_4_pressed() -> void:
	level = 4
	call_deferred("next_lvl")


func _on_level_5_pressed() -> void:
	level = 5
	call_deferred("next_lvl")


func _on_level_6_pressed() -> void:
	level = 6
	call_deferred("next_lvl")


func _on_level_7_pressed() -> void:
	level = 7
	call_deferred("next_lvl")


func _on_level_8_pressed() -> void:
	level = 8
	call_deferred("next_lvl")

func _on_level_9_pressed() -> void:
	level = 9
	call_deferred("next_lvl")

func _on_level_10_pressed() -> void:
	level = 10
	call_deferred("next_lvl")

func _on_level_11_pressed() -> void:
	level = 11
	call_deferred("next_lvl")

func _on_level_12_pressed() -> void:
	level = 12
	call_deferred("next_lvl")

func _on_level_13_pressed() -> void:
	level = 13
	call_deferred("next_lvl")

func _on_level_14_pressed() -> void:
	level = 14
	call_deferred("next_lvl")
