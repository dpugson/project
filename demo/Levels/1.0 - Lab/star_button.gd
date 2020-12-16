extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

signal activated

func _on_PlayerDetectionZone_body_entered(body):
	animated_sprite.frame = 1
	timer.stop()
	emit_signal("activated")

func _on_PlayerDetectionZone_body_exited(body):
	timer.start()

func _on_Timer_timeout():
	animated_sprite.frame = 0
