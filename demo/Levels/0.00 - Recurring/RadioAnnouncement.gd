extends Node2D

onready var stats = PlayerStats
onready var animation = $AnimationPlayer
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var timer = $Timer
onready var transition = Transition

const RADIO_PITCH = 1.2
const RADIO_SPEECH_SPEED = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("brighten")

func go():
	if stats.spawn_metadata == null:
		stats.spawn_metadata = "MISSING DOG"
	match stats.spawn_metadata:
		"MISSING DOG":
			missing_dog_0()

func missing_dog_0():
	timer.wait_time = 1
	timer.connect("timeout", self, "missing_dog_1")
	timer.start()

func missing_dog_1():
	timer.disconnect("timeout", self, "missing_dog_1")
	# type, text, wait time, next (options), action, picture, pitch
	var dialogue = {
		"begin" : [
			"TEXT", "...", RADIO_SPEECH_SPEED, 
			"begin2", null, null, RADIO_PITCH
		],
		"begin2" : [
			"TEXT", "THIS JUST IN...", RADIO_SPEECH_SPEED, 
			"begin3", null, null, RADIO_PITCH
		],
		"begin3" : [
			"TEXT", "THE QUEEN'S BELOVED PUPPY HAS BEEN REPORTED MISSING.", RADIO_SPEECH_SPEED, 
			"2", null, null, RADIO_PITCH
		],
		"2" : [
			"TEXT", "THE CIRCUMSTANCES SURROUNDING THE MISSING PUPPY'S\n" +\
					"DISAPPEARANCE REMAIN SHROUDED IN MYSTERY.",
			RADIO_SPEECH_SPEED, 
			"3", null, null, RADIO_PITCH
		],
		"3" : [
			"TEXT", "WILL THE PUPPY EVER BE FOUND?", RADIO_SPEECH_SPEED, 
			"2.1", null, null, RADIO_PITCH
		],
		"2.1" : [
			"TEXT", "IS THE PUPPY ALONE?", RADIO_SPEECH_SPEED, 
			"2.2", null, null, RADIO_PITCH
		],
		"2.2" : [
			"TEXT", "IS THE PUPPY SCARED?", RADIO_SPEECH_SPEED, 
			"4", null, null, RADIO_PITCH
		],
		"4" : [
			"TEXT", "STAY TUNED FOR UPDATES IN THIS QUICKLY EVOLVING STORY.", RADIO_SPEECH_SPEED, 
			null, null, null, RADIO_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "missing_dog_2"])

var closer = null
func ended():
	if closer != null:
		self.call(closer)

func missing_dog_2():
	closer = "missing_dog_closer"
	animation.play("dim")

func missing_dog_closer():
	transition.go_to("res://Levels/1.0 - Lab/Bathroom.tscn", "emerge_cutscene")
