extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite

const chuffed = "res://sprites/cavestuff/salamanders/pink_react0.png"
const thinking = "res://sprites/cavestuff/salamanders/pict_react1.png"

var dialogue = {
	"begin" : ["TEXT", "You're doing great!", 0.08, null]
}

func set_dialogue(new_dialogue):
	person.set_dialogue(new_dialogue)

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
