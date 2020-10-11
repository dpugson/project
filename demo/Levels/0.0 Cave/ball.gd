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
		[self, "grab_and_remove_ball"]
	]
}

func _ready():
	if stats.check_bool(TOOKBALL):
		remove_ball()
		
func grab_ball():
	stats.world_state[TOOKBALL] = true
	stats.inventory_add('ball')

func grab_and_remove_ball():
	grab_ball()
	remove_ball()
	
func grab_and_hide_ball():
	grab_ball()
	self.visible = false
	
func remove_ball():
	queue_free()

func _on_SeenBox_seen(_obj):
	DialogueHelper.showDialogue(self, dialogue)
