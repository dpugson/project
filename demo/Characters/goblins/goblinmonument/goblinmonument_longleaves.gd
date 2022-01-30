extends Node2D

onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_PlayerDetectionZone_body_entered(_body):
	animation.play("rustle")
