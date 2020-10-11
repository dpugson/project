extends YSort

var num_barks: int = 0

onready var hurt_box = $HurtBox
onready var popping_zone_center = $popping_zone_center
onready var EffectHelper = preload("res://effects/EffectHelper.gd")
onready var SalamanderPoppingEffect = preload("res://effects/SalamanderPeek.tscn")

var is_out = false

signal cutscene_starting

func popup_done():
	hurt_box.invincible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pop_up_salamander():
	var position = popping_zone_center.global_position
	var x_offset = rand_range(-350, 350)
	var y_offset = rand_range(-200, 15)
	position.x += x_offset
	position.y += y_offset
	EffectHelper.place_effect(
		self, SalamanderPoppingEffect, position,
		[self, "popup_done"])

func _on_HurtBox_area_entered(_area):
	hurt_box.invincible = true
	if num_barks > 3:
		Jukebox.play_song("res://tunes/cave/salamanders.wav")
		emit_signal("cutscene_starting")
		queue_free()
		return
	else:
		num_barks += 1
		pop_up_salamander()
		return
