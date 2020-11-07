extends Panel

onready var controls = $Controls
onready var stats = PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_labels()
	
func refresh_labels():
	var control_items = [
		"WASD: move", 
		"M: menu",
		"L: look / confirm",
		"K: bark",
		"I: view inventory"
	]
	if stats.check_bool("turbodash"):
		control_items.append("J: turbo dash")
	var control_string = "CONTROLS\n\n"
	for item in control_items:
		control_string += item + "\n"
	controls.text = control_string
