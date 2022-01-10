extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const PITCH = 3.6
const SPEED = 0.04
const CHASTISED = "res://sprites/random_npcs/snegurochka/snegurochka_react_chastised.png"
const GLEEFUL = "res://sprites/random_npcs/snegurochka/snegurochka_react_gleeful.png"
const NEUTRAL = "res://sprites/random_npcs/snegurochka/snegurochka_react_neutral.png"

onready var collisionshape = $SeenBox/CollisionShape2D

func set_dialogue(new_dialogue):
	self.dialogue = new_dialogue

var dialogue = {
	"begin" : [
		"TEXT", "Hmm... I have much to ponder...", 
		SPEED, null, null, NEUTRAL, PITCH
	]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_SeenBox_seen(_obj):
	DialogueHelper.showDialogue(self, dialogue)

func set_can_talk(boolean):
	collisionshape.disabled = not boolean
