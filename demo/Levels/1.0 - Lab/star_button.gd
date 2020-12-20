extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

signal activated(obj)
signal deactivated

func _on_PlayerDetectionZone_body_entered(_body):
	timer.stop()
	if animated_sprite.frame != 1:
		animated_sprite.frame = 1
		emit_signal("activated", self)

func _on_PlayerDetectionZone_body_exited(_body):
	#timer.start()
	pass

func _on_Timer_timeout():
	animated_sprite.frame = 0
	emit_signal("deactivated")

func deactivate():
	animated_sprite.frame = 0
