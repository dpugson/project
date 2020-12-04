extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var timer = $Timer

func _ready():
	timer.start()

func _on_Timer_timeout():
	if animated_sprite.speed_scale >= 5:
		timer.stop()
		return
	else:
		animated_sprite.speed_scale += 1
