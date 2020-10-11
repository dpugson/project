extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var stats = $Stats
const DestructionEffect = preload("res://effects/signexplode.tscn")
const DestructionEffect2 = preload("res://effects/EnemyDeathEffect.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")
export var max_health = 4

export(String, MULTILINE) var text : String = "This is a sign!"

export var unique_name : String = ""
var destroyed_stat_name = ""
export(String, MULTILINE) var revive_text = ""

func _ready():
	destroyed_stat_name = unique_name + "_SIGN_DESTROYED"
	if unique_name != "":
		if PlayerStats.check_bool(destroyed_stat_name):
			if revive_text != "":
				text = revive_text
			else:
				queue_free()
	stats.max_health = max_health 
	stats.health = max_health

func _on_SeenBox_seen(_obj):
	var dialogue = {
		"begin" : ["TEXT", text, 0.03, null]
	}
	DialogueHelper.showDialogue(self, dialogue)

func _on_Stats_out_of_health():
	PlayerStats.world_state[destroyed_stat_name] = true
	queue_free()
	EffectHelper.place_effect(self, DestructionEffect)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
