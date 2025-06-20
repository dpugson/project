extends Node2D

onready var star_animator = $BG/star_animator
onready var swayer = $FG/elevator/elevator_swayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("accept"):
		star_animator.play("elevator_start")

func start_stars():
	star_animator.playback_speed = .5
	star_animator.play("stars_start")

func continue_stars():
	swayer.play("sway")
	star_animator.playback_speed = .8
	star_animator.play("stars_going")
