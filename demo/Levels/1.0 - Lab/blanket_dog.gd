extends Sprite

export var paralyzed = true

signal unwrapped

func _input(event):
	if paralyzed:
		return
	if (event.is_action_pressed("ui_left")
		or event.is_action_pressed("ui_right")
		or event.is_action_pressed("ui_up")
		or event.is_action_pressed("ui_down")):
		self.queue_free()
		emit_signal("unwrapped")
