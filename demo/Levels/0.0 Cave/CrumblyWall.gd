extends Node2D

onready var stats = $Stats
onready var animation = $AnimationPlayer
onready var hurtbox = $HurtBox

var destroyed_stat_name = ""
export(String) var unique_name = ""
export(int) var max_health = 8

func _ready():
	stats.max_health = max_health
	stats.health = max_health
	destroyed_stat_name = unique_name + "_DESTROYED"
	if unique_name != "":
		if PlayerStats.check_bool(destroyed_stat_name):
			queue_free()
	stats.max_health = max_health 
	stats.health = max_health

func _on_Stats_out_of_health():
	hurtbox.invincible = true
	PlayerStats.world_state[destroyed_stat_name] = true
	animation.play("crumble")

func _on_HurtBox_area_entered(area):
	stats.health -= 1
	animation.play("shake")
	stats.health -= area.damage
