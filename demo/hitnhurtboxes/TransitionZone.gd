extends Area2D

signal transition_triggered

func _on_TransitionZone_body_entered(body):
	emit_signal("transition_triggered")
