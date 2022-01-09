extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite 

const chuffed = "res://sprites/cavestuff/salamanders/pink_react0.png"
const thinking = "res://sprites/cavestuff/salamanders/pict_react1.png"

const PITCH = 2.8
const SPEED = 0.04
const WORRIED = "res://sprites/random_npcs/otterbear/otterbear_react_worried-min.png"
const NEUTRAL = "res://sprites/random_npcs/otterbear/otterbear_react_neutral-min.png"

func set_dialogue(new_dialogue):
	self.dialogue = new_dialogue
	
func turn_to_sneg():
	person.set_direction2(Vector2.RIGHT)

var dialogue = {
	"begin" : [
		"TEXT", "Oh, my little Snegurochka...", 
		SPEED, null, null, WORRIED, PITCH
	]
}

func _ready():
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
	person.set_dialogue_callback([self, "turn_to_sneg"])

func set_can_talk(boolean):
	person.set_can_talk(boolean)
