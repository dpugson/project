extends Sprite

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var stats = PlayerStats

const TOOKBALL = "ball_took_ball"

onready var dialogue = {
	"begin" : [
		"TEXT", "IT'S YOUR BALL!!!!!!", 0.01,
		[
			["GRAB IT", "grab"],
		]
	],
	"grab" : [
		"ACTION", "You joyfully grab your greatest treasure", 0.01,
		null,
		[self, "grab_ball"]
	]
}

func _ready():
	if stats.check_bool(TOOKBALL):
		remove_ball()

func grab_ball():
	stats.world_state[TOOKBALL] = true
	stats.inventory_add('ball')
	remove_ball()
	
func remove_ball():
	queue_free()

func _on_SeenBox_seen():
	DialogueHelper.showDialogue(self, dialogue)
