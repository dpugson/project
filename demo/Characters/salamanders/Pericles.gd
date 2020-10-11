extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

var dialogue = {
	"begin" : ["TEXT", "You're doing great!", 0.08, null]
}

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
