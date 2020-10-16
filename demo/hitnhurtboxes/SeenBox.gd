extends Area2D

signal seen(obj)

func get_seen(obj):
	emit_signal("seen", obj)

