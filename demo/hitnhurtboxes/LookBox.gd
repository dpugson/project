extends Area2D

onready var collisionShape = $CollisionShape2D

signal saw_something

func _input(event):
	if event.is_action_pressed("look"):
		print("HMM")
		var areas = self.get_overlapping_areas()
		if areas.size() >= 1:
			emit_signal("saw_something")
			areas[0].get_seen()
