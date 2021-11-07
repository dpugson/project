extends Area2D

export(bool) var disabled = true

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if not self.disabled:
		check()

func check():
	var areas = self.get_overlapping_areas() + self.get_overlapping_bodies()
	for area in areas:
		print(len(areas))
		if not area.has_node("nograb"):
			emit_signal("hit")
			return
