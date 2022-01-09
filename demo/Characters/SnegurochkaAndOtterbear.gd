extends YSort

onready var sneg = $snegurochka
onready var ob = $otterbear
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func activate():
	sneg.set_can_talk(true)
	ob.set_can_talk(true)

func deactivate():
	sneg.set_can_talk(false)
	ob.set_can_talk(false)

func get_dialogue():
	return {
		"begin" : [
			"TEXT", "Father!!!", 
			sneg.SPEED, "2", null, sneg.NEUTRAL, sneg.PITCH
		],
		"2" : [
			"TEXT", "Yes, Snegurochka?", 
			ob.SPEED, "3", null, ob.NEUTRAL, ob.PITCH
		],
		"3" : [
			"TEXT", "I have a question!", 
			sneg.SPEED, "4", null, sneg.NEUTRAL, sneg.PITCH
		],
		"4" : [
			"TEXT", "Alright! Go ahead.", 
			ob.SPEED, "5", null, ob.NEUTRAL, ob.PITCH
		],
		"5" : [
			"TEXT", "Is it wrong to take something that doesn't belong to you?", 
			sneg.SPEED, "6", null, sneg.NEUTRAL, sneg.PITCH
		],
		"6" : [
			"TEXT", "Yes, Snegurochka! That is bad.", 
			ob.SPEED, "6.1", null, ob.NEUTRAL, ob.PITCH
		],
		"6.1" : [
			"TEXT", "That is called 'stealing'.", 
			ob.SPEED, "7", null, ob.NEUTRAL, ob.PITCH
		],
		"7" : [
			"TEXT", "Oh... I see.", 
			sneg.SPEED, "9", null, sneg.NEUTRAL, sneg.PITCH
		],
		"9" : [
			"TEXT", "But...", 
			sneg.SPEED, "9.1", null, sneg.CHASTISED, sneg.PITCH
		],
		"9.1" : [
			"TEXT", "What if you really really really want it?", 
			sneg.SPEED, "10", null, sneg.GLEEFUL, sneg.PITCH
		],
		"10": [
			"TEXT", "Yes!", 
			ob.SPEED, "10.1", null, ob.WORRIED, ob.PITCH
		],
		"10.1": [
			"TEXT", "That is still wrong.", 
			ob.SPEED, "11", null, ob.NEUTRAL, ob.PITCH
		],
		"11" : [
			"TEXT", "Oh...", 
			sneg.SPEED, "12", null, sneg.CHASTISED, sneg.PITCH
		],
		"12" : [
			"TEXT", "Hmm...", 
			sneg.SPEED, "13.1", null, sneg.NEUTRAL, sneg.PITCH
		],
		"13.1" : [
			"TEXT", "But what if I have already taken it?", 
			sneg.SPEED, "14", null, sneg.CHASTISED, sneg.PITCH
		],
		"14": [
			"TEXT", "Yes, Snegurochka!!!", 
			ob.SPEED, "14.1", null, ob.WORRIED, ob.PITCH
		],
		"14.1": [
			"TEXT", "That is still bad!", 
			ob.SPEED, "15.1", null, ob.NEUTRAL, ob.PITCH
		],
		"15.1" : [
			"TEXT", "Oh...", 
			sneg.SPEED, "15.2", null, sneg.CHASTISED, sneg.PITCH
		],
		"15.2" : [
			"TEXT", "I see!", 
			sneg.SPEED, "15", null, sneg.GLEEFUL, sneg.PITCH
		],
		"15" : [
			"TEXT", "Thank you father!", 
			sneg.SPEED, "16", null, sneg.GLEEFUL, sneg.PITCH
		],
		"16" : [
			"TEXT", "I see I still have much to learn.", 
			sneg.SPEED, "end", null, sneg.NEUTRAL, sneg.PITCH
		],
		"end": [
			"TEXT", "Oh, my little Snegurochka...", 
			ob.SPEED, null, null, ob.WORRIED, ob.PITCH
		],
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	deactivate()
	ob.person.set_direction2(Vector2.RIGHT)

func _on_SeenBox_seen(obj):
	DialogueHelper.showDialogue(self, get_dialogue(), false, null)
