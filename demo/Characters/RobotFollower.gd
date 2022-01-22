extends KinematicBody2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

export(bool) var watch_player = true
export(NodePath) var player_path = null
var player = null

const NEUTRAL = "res://Characters/RobotAA/Sprites/reacts/roboreact_neutral-min.png"
const DOWN = "res://Characters/RobotAA/Sprites/reacts/roboreact_down-min.png"
const EBULLIANT = "res://Characters/RobotAA/Sprites/reacts/roboreact_ebulliant-min.png"

# vocal stuff
var PITCH = 2
var SPEED = 0.05
var FAST_SPEED = 0.04

# movement
export var SLOW_DOWN = 5000
export var MAX_SPEED = 250
export var MAX_FLEE_SPEED = 500
export var SPEED_UP = 800
export var KNOCK_BACK = 800
export var BUMP_SPEED = 500
export var DISTANCE_FROM_PLAYER = 200

var words = "It's beautiful out, isn't it?"
var dialogue = {
	"begin" : ["TEXT", words, SPEED, null, null, null, PITCH]
}

func say_line(val, emotion=null):
	return ["TEXT", val, SPEED, null, null, emotion, PITCH]

func say(val, emotion=null):
	return {
		"begin" : ["TEXT", val, SPEED, null, null, emotion, PITCH]
	}

func silent(val):
	return {
		"begin" : ["TEXT", val, SPEED, null, null, null, null]
	}

var dialogue_index = 0
var dialogue_list = []

var is_hidden = false

enum {
	IDLE,
	WANDER,
	CHASE,
	FLEE
}

var state = IDLE
var speed = Vector2.ZERO

func _ready():
	person.watchPlayer = watch_player
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
	state = IDLE
	player = get_node(player_path)

func set_dialogue(dialogue_inp):
	person.set_dialogue(dialogue_inp)

func set_dialogue_callback(callback_inp):
	person.callback = callback_inp

func set_dialogue_list(val):
	dialogue_list = val
	set_dialogue_callback([self, "advance_list"])
	advance_list()

func hidden_mode(hide=true):
	is_hidden = hide

func advance_list():
	if dialogue_index < len(dialogue_list):
		var new_dialogue = dialogue_list[dialogue_index]
		dialogue_index += 1
		set_dialogue(new_dialogue)

func _physics_process(delta):
	if is_hidden:
		return
	var difference = player.global_position - self.global_position
	var distance = player.global_position.distance_to(self.global_position)
	match state:
		IDLE:
			speed = speed.move_toward(Vector2.ZERO, delta * SLOW_DOWN)
			animated_sprite.playing = false
			if distance > DISTANCE_FROM_PLAYER:
				state = CHASE
				animated_sprite.playing = true
		CHASE:
			var direction = (difference).normalized()
			speed = speed.move_toward(direction * MAX_SPEED, SPEED_UP * delta)
			if distance <= DISTANCE_FROM_PLAYER:
				state = IDLE
				animated_sprite.playing = false
				animated_sprite.frame = 0
	speed = move_and_slide(speed)


func up():
	animated_sprite.animation = "up"

func down():
	animated_sprite.animation = "down"

func right():
	animated_sprite.animation = "right"

func left():
	animated_sprite.animation = "left"
