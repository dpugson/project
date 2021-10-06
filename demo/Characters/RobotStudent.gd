extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

export(bool) var watch_player = true

var ROBOT_PITCH = 2
var ROBOT_SPEECH_SPEED = 0.05

var words = "Excuse me, doggy, I'm on the phone!"
var dialogue = {
	"begin" : ["TEXT", words, ROBOT_SPEECH_SPEED, null, null, null, ROBOT_PITCH]
}

func _ready():
	person.watchPlayer = watch_player
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
