extends StaticBody2D

signal slammed(power)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_slammed(power):
	emit_signal("slammed", power)
