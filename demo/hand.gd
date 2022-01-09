extends Node2D

export var splash = false

onready var animation_player = $AnimationPlayer
onready var timer = $Timer

export(float) var appear_delay = 1

signal appeared

func _ready():
	if splash:
		animation_player.play("before_appear")
		if appear_delay > 0:
			timer.wait_time = appear_delay
			timer.connect("timeout", self, "play_splash_appear")
			timer.start()
		else:
			animation_player.play("appear")
	else:
		animation_player.play("default")

func play_splash_appear():
	animation_player.play("appear")
	
func appeared():
	emit_signal("appeared")
