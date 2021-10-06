extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

export(bool) var on_top = false
export(Array, String, MULTILINE) var description = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_SeenBox_seen(obj):
	if description != null:
		DialogueHelper.showDialogueSimple(
			self, description, 0.05, null, on_top)
