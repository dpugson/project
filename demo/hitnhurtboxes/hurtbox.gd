extends Area2D

const Effect = preload("res://effects/HitEffect.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")

export(bool) var show_hit = false

func _on_HurtBox_area_entered(area):
	if show_hit:
		EffectHelper.place_effect_global(self, Effect)
