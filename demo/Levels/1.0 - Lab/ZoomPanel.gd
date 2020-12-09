extends Node2D

onready var animation = $AnimatedSprite

var original_animation = null

signal activated;

func _ready():
	original_animation = animation.animation

func _on_PlayerDetectionZone_body_entered(_body):
	animation.animation = "activated"
	emit_signal("activated")

func _on_PlayerDetectionZone_body_exited(_body):
	animation.animation = original_animation
