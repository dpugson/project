extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text" 

var speed = Vector2.ZERO
export var SPEED_UP = 9000;
export var MAX_SPEED = 1000;
export var SLOW_DOWN = 6000;

onready var hurtbox = $HurtBox
onready var stats = PlayerStats
onready var animation = $AnimationPlayer

export(bool) var cutscene_mode = false

func get_input(_delta) -> Vector2:
	var input = Vector2.ZERO
	if not cutscene_mode:
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input = input.normalized()
	return input

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var input = get_input(delta)
	if input != Vector2.ZERO:
		speed = speed.move_toward(input * MAX_SPEED, SPEED_UP * delta)
	else:
		speed = speed.move_toward(Vector2.ZERO, SLOW_DOWN * delta)
	var _discard = move_and_collide(speed * delta)

func _on_HurtBox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(1.6)
	animation.play("invincible")
