extends Node2D

const DestructionEffect = preload("res://effects/leaf_pile_explode.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")

func _on_HurtBox_area_entered(_area):
	queue_free()
	EffectHelper.place_effect(self, DestructionEffect)
