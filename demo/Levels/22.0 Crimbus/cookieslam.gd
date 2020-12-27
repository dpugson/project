extends StaticBody2D

signal slammed

func get_slammed(_power):
	emit_signal("slammed")
