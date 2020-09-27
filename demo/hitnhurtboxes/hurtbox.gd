extends Area2D

const Effect = preload("res://effects/HitEffect.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")

export(bool) var show_hit = false

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func _on_HurtBox_area_entered(area):
	if show_hit:
		EffectHelper.place_effect_global(self, Effect)
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func set_invincible(value):
	invincible = value
	match invincible:
		true:
			emit_signal("invincibility_started")
		false:
			emit_signal("invincibility_ended")

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", false)

func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable", true)
