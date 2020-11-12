extends Area2D

signal rotate(direction)

func rotate(direction):
	emit_signal("rotate", direction)
