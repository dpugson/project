extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite 
export(Vector2) var start_direction = Vector2.DOWN

const PITCH = 2.8
const SPEED = 0.04

func right():
	person.set_direction2(Vector2.RIGHT)

func left():
	person.set_direction2(Vector2.LEFT)

func up():
	person.set_direction2(Vector2.UP)

func down():
	person.set_direction2(Vector2.DOWN)

var dialogue = {
	"begin" : [
		"TEXT", "H-h-hello!", 
		SPEED, null, null, null, PITCH
	]
}

func _ready():
	person.init(animated_sprite)
	person.set_direction2(start_direction)
	person.set_dialogue(dialogue)

func set_can_talk(boolean):
	person.set_can_talk(boolean)

func set_dialogue(dialogue, callback=null):
	person.set_dialogue(dialogue)
	person.set_dialogue(callback)
