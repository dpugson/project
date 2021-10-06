extends Node2D

onready var barrier = $StaticBody2D/CollisionShape2D
onready var stats = PlayerStats
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

export(String) var unlock_var_name = null
export(Array, String, MULTILINE) var locked_description = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if unlock_var_name != null:
		if stats.check_bool(unlock_var_name):
			unlock()
		else:
			lock()
	pass # Replace with function body.

func unlock():
	barrier.disabled = true

func lock():
	barrier.disabled = false


func _on_SeenBox_seen(obj):
	if locked_description != null and barrier.disabled == false:
		DialogueHelper.showDialogueSimple(
			self, locked_description, 0.05, null, true)
