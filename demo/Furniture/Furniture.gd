extends Node2D

onready var animated_sprite = $AnimatedSprite

var directions = [
	"left",
	"up",
	"right",
	"down"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_left"):
		turn_clockwise()
	elif event.is_action_pressed("ui_right"):
		turn_counterclockwise()

func turn_clockwise():
	var current_direction = animated_sprite.animation
	var index = directions.find(current_direction)
	var new_direction = directions[(index + 1) % len(directions)]
	animated_sprite.animation = new_direction

func turn_counterclockwise():
	var current_direction = animated_sprite.animation
	var index = directions.find(current_direction)
	var new_direction = directions[(index - 1) % len(directions)]
	animated_sprite.animation = new_direction

func interact():
	pass
