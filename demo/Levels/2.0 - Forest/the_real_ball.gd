extends Sprite

onready var stats = PlayerStats
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const TAKEN = "the_real_ball_taken"

export(bool) var show_top = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if stats.check_bool(TAKEN):
		self.queue_free()
		return

var dialogue = {
	"begin" : [
		"TEXT", 
		"It's a strange ball... Something... About it...", 0.03,
		[
			["take", "take"],
			["leave", "leave"]
		]
	],
	"leave" : [
		"TEXT",
		"Yeah... That's better. Best forget...\nBetter to leave it...", 0.03, null
	],
	"take" : [
		"ACTION", "YOU ACQUIRE THE REAL BALL.", 0.03, null, [self, "grab_ball"]
	]
}

func grab_ball():
	stats.world_state[TAKEN] = true
	stats.inventory_add('real_ball')
	self.queue_free()

func _on_SeenBox_seen(_obj):
	DialogueHelper.showDialogue(self, dialogue, show_top)
