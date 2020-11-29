extends Node2D

onready var stats = PlayerStats
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var seen_box = $SeenBox
onready var collision_shape = $SeenBox/CollisionShape2D

export var save_spot_name = "DefaultSaveSpot"
export(String) var home = null
export(String, MULTILINE) var flavor_text = "The smell of adventure fills you with determination!"

func _ready():
	save_dialogue["begin"] = [
		"TEXT", flavor_text, 0.03, "query"
	]
	if home == null:
		collision_shape.disabled = true
		seen_box.visible = false
		

var save_dialogue = {
	"query" : [
		"TEXT", "Would you like to save?", 0.03,
		[["Yes", "save"], ["No", null]]
	],
	"save" : [
		"Text", "Your game has been saved!", 0.03,
		null, [self, "save_game"]
	]
}

func save_game():
	stats.save_game(save_spot_name, home)

func _on_SeenBox_seen(_obj):
	if home != null:
		DialogueHelper.showDialogue(self, save_dialogue)
