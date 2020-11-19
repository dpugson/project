extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var gilby = $YSort/Gilby
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var animation = $AnimationPlayer
onready var beatSkeletonSpawnPoint = $BeatSkeletonSpawnPoint
onready var skeleton_event_trigger = $SkeletonEventTrigger
onready var save_star = $YSort/SaveStar

const already_been_in_here = "ALREADY_BEEN_IN_SKELTON_HOUSE"
const beat_skeleton = "BEAT_SKELETON"
const skeleton_inside = "THE_SKELETON_GONE_INSIDE"
const SKELETON_VOICE_PITCH = 0.5
const SKELETON_SPEECH_RATE = 0.06

func _ready():
	Jukebox.stop()
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	
	match stats.spawn_metadata:
		"Caves - Outside the Skeleton's House":
			player_position = save_star.position
			orientation = Vector2.UP
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
		"top":
			player_position = topSpawnPoint.position
			orientation = Vector2.DOWN
		"beat_game":
			player_position = beatSkeletonSpawnPoint.position
			orientation = Vector2.UP
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
	
	if not stats.check_bool(already_been_in_here):
		gilby.connect("appeared", self, "opine")
	gilby.set_dialogue(get_normal_dialogue(gilby.VOICE_PITCH))
	
	if stats.check_bool(beat_skeleton):
		skeleton_event_trigger.queue_free()
		Jukebox.play_song("res://tunes/cave/fallen.wav")
		if !stats.check_bool(skeleton_inside) && stats.spawn_metadata == "beat_game":
			player.cutscene_mode = true
			player.set_blend_positions(Vector2.UP)
			animation.play("FinishedBattle")

func play_post_battle_dialogue():
	DialogueHelper.showDialogue(self, post_battle_dialogue, false, [self, "bounce_away"])

var post_battle_dialogue = {
	"begin" : [
		"TEXT", "...",
		SKELETON_SPEECH_RATE, "2", null, null, SKELETON_VOICE_PITCH
	],
	"2" : [
		"TEXT", "HEHEHEHEH!!!",
		SKELETON_SPEECH_RATE, "3", null, null, SKELETON_VOICE_PITCH
	],
	"3" : [
		"TEXT", "SILLY PUPPY!",
		SKELETON_SPEECH_RATE, "32", null, null, SKELETON_VOICE_PITCH
	],
	"32" : [
		"TEXT", "YOU'RE SPUNKY!",
		SKELETON_SPEECH_RATE, null, null, null, SKELETON_VOICE_PITCH
	],
}

func bounce_away():
	animation.play("bounce_away")

func bounce_completed():
	DialogueHelper.showDialogue(self, post_bounce_dialogue, false, [self, "go_inside"])

var post_bounce_dialogue = {
	"begin" : [
		"TEXT", "THEY ALWAYS SAY, QUIT WHILE YOU'RE A HEAD...",
		SKELETON_SPEECH_RATE, "1", null, null, SKELETON_VOICE_PITCH
	],
	"1" : [
		"TEXT", "...AND NOW I KNOW WHAT THEY'RE TALKING ABOUT!",
		SKELETON_SPEECH_RATE, "2", null, null, SKELETON_VOICE_PITCH
	],
	"2" : [
		"TEXT", "WELL, I FEEL LIKE AFTER ALL THIS FUN, I NEED A LOOOONG NAP.",
		SKELETON_SPEECH_RATE, "3", null, null, SKELETON_VOICE_PITCH
	],
	"3" : [
		"TEXT", "FEEL FREE TO COME IN AND TAKE A BREATHER!",
		SKELETON_SPEECH_RATE, "4", null, null, SKELETON_VOICE_PITCH
	],
	"4" : [
		"TEXT", "OH! AND... BY THE WAY",
		SKELETON_SPEECH_RATE, "52", null, null, SKELETON_VOICE_PITCH
	],
	"52" : [
		"TEXT", "THE FLIPPERS ARE IN THE BACK ROOM! CONSIDER THEM A GIFT FROM A FRIEND!",
		SKELETON_SPEECH_RATE, "5", null, null, SKELETON_VOICE_PITCH
	],
	"5" : [
		"TEXT", "SEE YOU ON THE FLIP SIDE",
		SKELETON_SPEECH_RATE, null, null, null, SKELETON_VOICE_PITCH
	],
}

func go_inside():
	animation.play("GoInHouse")

func go_inside_done():
	player.cutscene_mode = false
	stats.world_state[skeleton_inside] = true

func get_normal_dialogue(pitch):
	if not stats.check_bool(beat_skeleton):
		return {
			"begin" : [
				"TEXT", "GO GET EM!", 0.03,
				null, null, null, pitch
			]
		}
	else:
		return {
			"begin" : [
				"TEXT", "You did it! Way to go!!!\nI'll meet you back in the big room!", 0.03,
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
			"TEXT", "This guy... When he died he uh...",
			0.02, "warning512", null, gilby.shifty, gilby_voice
		], 
		"warning512" : [
			"TEXT", "Turned into a wrathful undead skeleton wraith!!!",
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
			"TEXT", "GO GET EM! (though I might save first if I were you.....)",
			0.02, null, null, gilby.angry, gilby_voice
		],
	}
	
func opine():
	stats.world_state[already_been_in_here] = true
	DialogueHelper.showDialogue(self, get_dialogue(gilby.VOICE_PITCH))

func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/SkelebonesLivingRoom.tscn", "bottom")

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave2.tscn", "top")
	
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
	if !stats.check_bool(beat_skeleton):
		player.state = player.WALK
		player.speed = Vector2.ZERO
		player.cutscene_mode = true
		Jukebox.stop()
		animation.play("StartEncounter")

func skeleton_encounter_dialogue():
	DialogueHelper.showDialogue(self, skeleton_dialogue)

func start_battle():
	Transition.go_to("res://MiniGames/battles/SkeletonBossFight.tscn")
