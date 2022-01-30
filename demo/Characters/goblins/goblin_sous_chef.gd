extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite 

const PITCH = 2.7
const SPEED = 0.04

var dialogue = {
	"begin" : [
		"TEXT", "BONJOUR!", 
		SPEED, null, null, null, PITCH
	]
}

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
	#person.set_dialogue_callback([self, "turn_to_sneg"])
