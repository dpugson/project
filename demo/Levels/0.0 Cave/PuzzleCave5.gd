extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var gilby = $YSort/Gilby
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const already_been_in_here = "ALREADY_BEEN_IN_PZC5"
const crates_exploded = "CRATES_EXPLODED"

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
		"top":
			player_position = topSpawnPoint.position
			orientation = Vector2.DOWN
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
	if not stats.check_bool(already_been_in_here):
		gilby.connect("appeared", self, "opine")
	gilby.set_dialogue(get_normal_dialogue(gilby.VOICE_PITCH))
	for crate in $YSort/Crates.get_children():
		if stats.check_bool(crates_exploded):
			crate.queue_free()
		else:
			crate.connect("special_box_seen", self, "talking_box")

func get_normal_dialogue(pitch):
	if stats.check_bool(crates_exploded):
		return {
			"begin" : [
				"TEXT", "Wha- they blew themselves to smithereens!!!",
				0.02, "next", null, gilby.shifty, pitch
			],
			"next" : [
				"TEXT", "That's messed up!!!", 0.03,
				null, null, null, pitch
			]
		}
	else:
		return {
			"begin" : [
				"TEXT", "I mean puzzle design is hard, but... Really!",
				0.03, "next", null, null, pitch
			],
			"next" : [
				"TEXT", "We're expected to pay money for this stuff?", 0.03,
				null, null, null, pitch
			]
		}

func get_dialogue(gilby_voice):
	return {
			"begin" : [
				"TEXT", "And this one isn't even solveable!!!",
				0.02, null, null, gilby.shifty, gilby_voice
			]
		}

onready var special_dialogue  = {
	"begin" : [
		"TEXT", "...", 0.03, [
			["zzzzzzzzzzzz...", "excuse"]
		]
	],
	"excuse" : [
		"TEXT", "Huh??? Who's there???", 0.03, [
			["Could you please get out of the way?", "out"]
		]
	],
	"out" : [
		"TEXT", "What? Why?", 0.03, [
			["I'm a sad puppy and I need to get home!!!", "woe"]
		]
	],
	"woe" : [
		"TEXT", "Your nobleness of spirit!!! I am so incredibly MOVED!!!!", 0.03,
		"comeon"
	],
	"comeon" : [
		"TEXT", "Come on, boxes!! Let's help this puppy out!!!", 0.03, "ofcourse"
	],
	"ofcourse" : [
		"TEXT", "!!!!!", 0.03, "WHOAH", [self, "explode"]
	],
	"WHOAH" : [
		"TEXT", "WHOAH!!!", 0.03, "wha", null, gilby.shifty, gilby.VOICE_PITCH
	],
	"wha" : [
		"TEXT", "Wha- they blew themselves to smithereens!!!",
		0.02, "next", null, gilby.shifty, gilby.VOICE_PITCH
	],
	"next" : [
		"TEXT", "That's messed up!!!", 0.03,
		null, null, null, gilby.VOICE_PITCH
	]
}

func talking_box():
	DialogueHelper.showDialogue(self, special_dialogue)

func explode():
	stats.world_state[crates_exploded] = true
	gilby.set_dialogue(get_normal_dialogue(gilby.VOICE_PITCH))
	for crate in $YSort/Crates.get_children():
		crate.explode()

func opine():
	stats.world_state[already_been_in_here] = true
	DialogueHelper.showDialogue(self, get_dialogue(gilby.VOICE_PITCH))

func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave2.tscn", "bottom")

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave4.tscn", "top")
