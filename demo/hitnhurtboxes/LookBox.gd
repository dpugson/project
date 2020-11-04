extends Area2D

onready var collisionShape = $CollisionShape2D

signal saw_something

export(bool) var disabled = false

func _input(event):
	if event.is_action_pressed("look"):
		if not disabled:
			var areas = self.get_overlapping_areas()
			if areas.size() >= 1:
				emit_signal("saw_something")
				areas[0].get_seen(self)
