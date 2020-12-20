extends Node2D

onready var animation = $AnimationPlayer

func start():
	animation.play("default")
