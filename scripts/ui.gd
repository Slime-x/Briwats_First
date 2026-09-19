extends CanvasLayer

@onready var startscreen: Control = $startscreen
@onready var choose_level: Control = $choose_level
var level_menu = false


func _ready():
	for button in get_tree().get_nodes_in_group("buttons"):
		button.focus_mode = Control.FOCUS_NONE


func _on_button_pressed(): #StartScreen Play button
	startscreen.hide()
	level_choice()
	level_available()
	
func level_available():
	var i = 1

	while i <= Gamemanager.level:
		var level = get_node("choose_level/level_" + str(i))
		level.show()
		i += 1
	


func _on_chooselevel_pressed(): # Onscreen/chooselevel
	level_choice()
		
func level_choice():
	if level_menu:
		choose_level.hide()
		level_menu = false
	else:
		level_menu = true
		choose_level.show()
