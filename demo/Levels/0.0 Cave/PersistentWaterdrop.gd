extends Node2D 

onready var Waterdrop = preload("res://Levels/0.0 Cave/Waterdrop.tscn")

onready var timer = $Timer
onready var start = $Start
onready var end = $End

export var wait_time: float = 3
export var fall_speed: float = 60

func _ready():
	timer.wait_time = wait_time
	timer.start()

func _on_Timer_timeout():
	var waterdrop = Waterdrop.instance()
	waterdrop.speed = fall_speed
	waterdrop.start = start.position
	waterdrop.end = end.position
	self.add_child(waterdrop)
	waterdrop.play()
