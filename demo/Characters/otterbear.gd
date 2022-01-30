extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite 
export(Vector2) var start_direction = Vector2.DOWN

const PITCH = 2.8
const SPEED = 0.04
const WORRIED = "res://sprites/random_npcs/otterbear/otterbear_react_worried-min.png"
const NEUTRAL = "res://sprites/random_npcs/otterbear/otterbear_react_neutral-min.png"

func turn_to_sneg():
	person.set_direction2(Vector2.RIGHT)

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
		"TEXT", "Oh, my little Snegurochka...", 
		SPEED, null, null, WORRIED, PITCH
	]
}

func _ready():
	person.init(animated_sprite)
	person.set_direction2(start_direction)
	person.set_dialogue(dialogue)
	person.set_dialogue_callback([self, "turn_to_sneg"])

func set_can_talk(boolean):
	person.set_can_talk(boolean)

func set_dialogue(dialogue_inp, callback=null):
	person.set_dialogue(dialogue_inp)
	person.set_dialogue(callback)
