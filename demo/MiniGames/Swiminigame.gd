extends Node2D

onready var swimbod = $CanvasLayer/swimbod

signal done

func _ready():
	swimbod.gravity = 2000

func _on_Timer_timeout():
	swimbod.gravity *= 0.5

func _on_TransitionZone_transition_triggered():
	Transition.play_animation()
	queue_free()
	emit_signal("done")
	
