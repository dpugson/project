extends Sprite

onready var seenBox = $SeenBox
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var stats = PlayerStats
onready var bone = $bone

var dialoguePopup = null

var dialogue = []

var dialogue_bone_there = {
	"begin" : [
		"TEXT", 
		"It's a dry old skelebones...", 0.03,
		[
			["Yup, cool.", null],
			["Hmm...", "considerbone"]
		]
	],
	"considerbone" : [
		"TEXT", 
		"This old skelebones probably wouldn't mind one more missing bone... right?", 0.02,
		[
			["Desecrate body", "takebone"],
			["Do not", "leavealone"]
		]
	],
	"leavealone" : [
		"TEXT",
		"Best let old bones lie.", 0.03, null
	],
	"takebone" : [
		"ACTION", "YOU ACQUIRE A BONE.", 0.03, null, [self, "grab_bone"]
	]
}

var dialogue_bone_gone = {
	"begin" : [
		"TEXT", 
		"It's a dry old skelebones, minus one bone...", 0.03,
		[
			["Thank Mr. Skeltal.", null],
		]
	],
}

const TOOKBONE = "skeleton_torso_took_bone"

func grab_bone():
	stats.world_state[TOOKBONE] = true
	stats.inventory_add('bone')
	remove_bone()
	
func remove_bone():
	dialogue = dialogue_bone_gone
	bone.queue_free()

func _ready():
	dialogue = dialogue_bone_there
	if stats.world_state.has(TOOKBONE):
		if stats.world_state[TOOKBONE]:
			remove_bone()
	seenBox.connect("seen", self, "showDialogue")

func showDialogue(_obj):
	DialogueHelper.showDialogue(self, dialogue)
