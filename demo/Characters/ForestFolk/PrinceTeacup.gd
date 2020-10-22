extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

const VOICE_PITCH = 1.9

var dialogue = {
	"begin" : ["TEXT", "Hmm?", 0.02, null, null, null, VOICE_PITCH]
}

func set_dialogue(new_dialogue):
	person.set_dialogue(new_dialogue)

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
