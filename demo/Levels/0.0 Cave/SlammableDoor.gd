extends Node2D

const DestructionEffect = preload("res://effects/signexplode.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var stats = PlayerStats

export var unlock_item : String = ""
export var unique_name : String = ""
var destroyed_stat_name = ""

export(String, MULTILINE) var text = "The door is locked..."

signal destroyed

func _ready():
	destroyed_stat_name = unique_name + "_DOOR_DESTROYED"
	if unique_name != "":
		if PlayerStats.check_bool(destroyed_stat_name):
			queue_free()

func _on_SeenBox_seen(_obj):
	var dialogue = null
	if unlock_item != "" and stats.inventory_get(unlock_item) > 0:
		dialogue = {
			"begin" : ["TEXT", 
				"The door is locked... But you have the key!\nWould you like to unlock it?", 0.03,
				[["yes", "unlock"], ["no", null]]
			],
			"unlock" : [
				"TEXT", "*click!*", 0.04, null, [self, "unlock"]
			]
		}
	else:
		dialogue = {
			"begin" : ["TEXT", text, 0.03, null]
		}
	DialogueHelper.showDialogue(self, dialogue)
	
func unlock():
	_on_Slammable_slammed(0)

func _on_Slammable_slammed(_power):
	if destroyed_stat_name != "":
		PlayerStats.world_state[destroyed_stat_name] = true
	queue_free()
	EffectHelper.place_effect_global(self, DestructionEffect)
	emit_signal("destroyed")
