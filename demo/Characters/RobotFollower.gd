extends KinematicBody2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

export(bool) var watch_player = true
export(NodePath) var player_path = null
var player = null

# vocal stuff
var PITCH = 2
var SPEED = 0.05

# movement
export var SLOW_DOWN = 5000
export var MAX_SPEED = 250
export var MAX_FLEE_SPEED = 500
export var SPEED_UP = 800
export var KNOCK_BACK = 800
export var BUMP_SPEED = 500
export var DISTANCE_FROM_PLAYER = 200

var words = "Hi doggy! It's beautiful out, isn't it?"
var dialogue = {
	"begin" : ["TEXT", words, SPEED, null, null, null, PITCH]
}

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

func _physics_process(delta):
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
	
