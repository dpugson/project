extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartuifull = $HeartUIFull
onready var heartuiempty = $HeartUIEmpty

const heart_image = preload("res://sprites/hearts/fullheart.png")
onready var heart_image_width = heart_image.get_width()

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartuifull != null:
		heartuifull.rect_size.x = hearts * heart_image_width
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartuiempty != null:
		heartuiempty.rect_size.x = max_hearts * heart_image_width
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
