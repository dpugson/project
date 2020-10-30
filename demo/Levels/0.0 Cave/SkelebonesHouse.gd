extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var gilby = $YSort/Gilby
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var animation = $AnimationPlayer

const already_been_in_here = "ALREADY_BEEN_IN_SKELTON_HOUSE"
const SKELETON_VOICE_PITCH = 0.5
const SKELETON_SPEECH_RATE = 0.06

func _ready():
	Jukebox.stop()
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

func get_normal_dialogue(pitch):
	return {
		"begin" : [
			"TEXT", "GO GET EM!", 0.03,
			null, null, null, pitch
		]
	}
	
func get_dialogue(gilby_voice):
	return {
		"begin" : [
			"TEXT", "You've made it! The house should be just right up this way.",
			0.02, "warning", null, gilby.shifty, gilby_voice
		],
		"warning" : [
			"TEXT", "...",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "Oh yeah!",
			0.02, "warning3", null, null, gilby_voice
		],
		"warning3" : [
			"TEXT", "Just one more thing.",
			0.02, "warning4", null, gilby.angry, gilby_voice
		],
		"warning4" : [
			"TEXT", "This guy... Is ummm...",
			0.02, "warning512", null, gilby.shifty, gilby_voice
		], 
		"warning512" : [
			"TEXT", "A wrathful undead skeleton!!!",
			0.02, "warning51", null, gilby.angry, gilby_voice
		], 
		"warning51" : [
			"TEXT", "Probably got that way on account of being so obsessed with\npuzzles!!!!!",
			0.02, "warning5", null, gilby.angry, gilby_voice
		],
		"warning5" : [
			"TEXT", "But that's nothing you can't handle, right?",
			0.02, "warning6", null, gilby.shifty, gilby_voice
		],
		"warning6" : [
			"TEXT", "You're a big muscly puppy!",
			0.02, "warning7", null, gilby.angry, gilby_voice
		],
		"warning7" : [
			"TEXT", "GO GET EM!",
			0.02, null, null, gilby.angry, gilby_voice
		],
	}
	
func opine():
	stats.world_state[already_been_in_here] = true
	DialogueHelper.showDialogue(self, get_dialogue(gilby.VOICE_PITCH))


func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/SkelebonesLivingRoom.tscn", "bottom")

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave5.tscn", "top")
	
var skeleton_dialogue = {
	"begin" : [
		"TEXT", "OH MY GOODNESS!!!!!",
		SKELETON_SPEECH_RATE, "2", null, null, SKELETON_VOICE_PITCH
	],
	"2" : [
		"TEXT", "A!!!! PUPPY!!!!!!!!!",
		SKELETON_SPEECH_RATE, "3", null, null, SKELETON_VOICE_PITCH
	],
	"3" : [
		"TEXT", "YOU ARE SO CUTE!!!!!",
		SKELETON_SPEECH_RATE, "4", null, null, SKELETON_VOICE_PITCH
	],
	"4" : [
		"TEXT", "AND FLUFFY!!!!!",
		SKELETON_SPEECH_RATE, "5", null, null, SKELETON_VOICE_PITCH
	],
	"5" : [
		"TEXT", "DID YOU LIKE MY PUZZLES????",
		SKELETON_SPEECH_RATE, [["yes", "yes"], ["no", "no"]], null, null, SKELETON_VOICE_PITCH
	],
	"yes" : [
		"TEXT", "HURRAY!!!!!!! That makes me VERY HAPPY.",
		SKELETON_SPEECH_RATE, "7", null, null, SKELETON_VOICE_PITCH
	],
	"no" : [
		"TEXT", "OH.... Well that's ok...",
		SKELETON_SPEECH_RATE, "7", null, null, SKELETON_VOICE_PITCH
	],
	"7" : [
		"TEXT", "OH, BUT!!!! IS THAT... A BALL???",
		SKELETON_SPEECH_RATE, [["Uhh, yeah, it is!", "8"]], null, null, SKELETON_VOICE_PITCH
	],
	"8" : [
		"TEXT", "DO YOU WANT TO PLAY FETCH???",
		SKELETON_SPEECH_RATE, [["YES!!!!!!!!!!!!", "9"]], null, null, SKELETON_VOICE_PITCH
	],
	"9" : [
		"TEXT", "",
		SKELETON_SPEECH_RATE, null, [self, "start_battle"], null, SKELETON_VOICE_PITCH
	],
}

func _on_SkeletonEventTrigger_transition_triggered():
	player.cutscene_mode = true
	Jukebox.stop()
	animation.play("StartEncounter")

func skeleton_encounter_dialogue():
	DialogueHelper.showDialogue(self, skeleton_dialogue)

func start_battle():
	Transition.go_to("res://MiniGames/battles/SkeletonBossFight.tscn")
