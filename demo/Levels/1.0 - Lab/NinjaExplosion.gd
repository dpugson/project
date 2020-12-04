extends Node2D

onready var animated_sprite = $AnimatedSprite

func ready():
	animated_sprite.visible = false

func play(function):
	animated_sprite.visible = true
	animated_sprite.connect("animation_finished", function[0], function[1])
	animated_sprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
