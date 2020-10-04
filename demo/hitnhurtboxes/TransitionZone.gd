extends Area2D

signal transition_triggered

onready var collisionShape = $CollisionShape2D

func set_active(value):
	collisionShape.set_deferred("disabled", value)
	
func _on_TransitionZone_body_entered(_body):
	emit_signal("transition_triggered")
