extends CanvasLayer

@onready var startscreen: Control = $startscreen
@onready var choose_level: Control = $choose_level



func _on_button_pressed(): #StartScreen Play button
	startscreen.hide()
	choose_level.show()
	level_available()
	
func level_available():
	var i = Gamemanager.level
	while i!= 0:
		if Gamemanager.level == i:
			var level = "$choose_level/level_" + str(i)
			level.show()
	
