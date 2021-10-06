extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

signal activated(obj)
signal deactivated

var frozen = false

func _on_PlayerDetectionZone_body_entered(_body):
	timer.stop()
	timer.wait_time = 3
	if animated_sprite.frame != 1:
		animated_sprite.frame = 1
		emit_signal("activated", self)

func _on_PlayerDetectionZone_body_exited(_body):
	if not frozen:
		timer.start()

func is_active():
	return animated_sprite.frame == 1

func freeze():
	frozen = true
	timer.stop()
	timer.wait_time = 3

func _on_Timer_timeout():
	animated_sprite.frame = 0
	emit_signal("deactivated")

func deactivate():
	frozen = false
	animated_sprite.frame = 0
