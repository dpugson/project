extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

var dialogue = {
	"begin" : ["TEXT", "See- it's LOVE! What did I tell ya?", 0.02, null, null, null, 1.5]
}

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)


