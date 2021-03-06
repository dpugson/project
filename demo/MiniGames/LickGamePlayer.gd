extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text" 

var speed = Vector2.ZERO
export var SPEED_UP = 9000;
export var MAX_SPEED = 1000;
export var SLOW_DOWN = 6000;

onready var stats = PlayerStats
onready var animation = $AnimationPlayer
onready var leapAnimationPlayer = $LeapAnimationPlayer
onready var slobber = $dog2/slobber
onready var player = $dog2

export(bool) var cutscene_mode = false

var stopped = false

enum {
	NORMAL,
	LEAPING
}

var state = NORMAL

func _ready():
	turn_off_spit()

func get_input(_delta) -> Vector2:
	var input = Vector2.ZERO
	if not cutscene_mode:
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input = input.normalized()
	return input

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if stopped:
		return
	match state:
		NORMAL:
			if (Input.is_action_just_pressed("ui_up")
				or Input.is_action_just_pressed("accept")
				or Input.is_action_just_pressed("bark")
				or Input.is_action_just_pressed("look")):
				state = LEAPING
				leapAnimationPlayer.play("leap")
			move(delta)
		LEAPING:
			move(delta)

func leap_complete():
	state = NORMAL

func move(delta):
	var input = get_input(delta)
	if input != Vector2.ZERO:
		speed = speed.move_toward(input * MAX_SPEED, SPEED_UP * delta)
	else:
		speed = speed.move_toward(Vector2.ZERO, SLOW_DOWN * delta)
	var _discard = move_and_collide(speed * delta)

func turn_on_spit():
	slobber.visible = true

func turn_off_spit():
	slobber.visible = false

func stop():
	var tween = Tween.new()
	tween.interpolate_property(
		player,
		"position",
		player.position,
		Vector2(0, 0),
		0.5
	)
	tween.connect("tween_completed", self, "delete_tween", [tween])
	self.add_child(tween)
	tween.start()
	stopped = true
	cutscene_mode = true

func delete_tween(_a, _b, tween):
	tween.queue_free()
