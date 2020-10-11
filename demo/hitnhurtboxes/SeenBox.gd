extends Area2D

signal seen

func get_seen(obj):
	emit_signal("seen", obj)
