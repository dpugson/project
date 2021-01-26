extends Node2D

onready var rect = $TextureRect

const MAX_HEIGHT = 526

func set_percentage(p):
	var new_height = MAX_HEIGHT - ((p/100.0) * MAX_HEIGHT)
	rect.rect_size.y = new_height
