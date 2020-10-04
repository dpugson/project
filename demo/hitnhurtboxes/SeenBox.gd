extends Area2D

signal seen

func get_seen():
	emit_signal("seen")
