extends KinematicBody2D

var speed = Vector2.ZERO

export var gravity = 580
export var terminal_velocity = 500
export var swim_power = Vector2.UP * 50

onready var animation = $swimbod/AnimationPlayer

var starting_pos

func _input(event):
	if event.is_action_pressed("bark") or event.is_action_pressed("look"):
		speed += swim_power
		animation.play("SWIM_DOWN")

func _ready():
	starting_pos = self.global_position

func _physics_process(delta):
	speed += delta * (Vector2.DOWN * gravity)
	if speed.y > terminal_velocity:
		speed.y = terminal_velocity
	speed = self.move_and_slide(speed)

