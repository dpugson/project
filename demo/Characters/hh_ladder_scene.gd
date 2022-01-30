extends Node2D

onready var hh = $"ladder-min/hh"

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const PITCH = 2.8
const SPEED = 0.04


var state = "begin"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_SeenBox_seen(obj):
	var dialogue 
	match state:
		"begin":
			hh.scream()
			dialogue = {
				"begin" : [
					"TEXT", "EW! A DOG!", SPEED,
					null, null, null, PITCH
				],
			}
			state = "GOAWAY"
			DialogueHelper.showDialogue(
				self, dialogue, false, [hh, "neutral"])
		_:
			dialogue = {
				"begin" : [
					"TEXT", "HISSSS!!!!!!!!!!!!!", SPEED,
					"2", null, null, PITCH
				],
				"2" : [
					"TEXT", "HISSS HISS HISSS!!!!!!!!!!!!!", SPEED,
					null, null, null, PITCH
				],
			}
			hh.freakout()
			DialogueHelper.showDialogue(
				self, dialogue, false, [hh, "neutral"])
	
