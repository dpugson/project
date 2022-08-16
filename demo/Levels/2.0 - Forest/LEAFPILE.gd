extends Node2D

onready var audio = $AudioStreamPlayer

const DestructionEffect = preload("res://effects/leaf_pile_explode.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")

func explode():
	audio.play()
	for i in 19:
		var leafpile = get_node("leaf" + str(i))
		EffectHelper.place_effect(leafpile, DestructionEffect)
		leafpile.queue_free()
