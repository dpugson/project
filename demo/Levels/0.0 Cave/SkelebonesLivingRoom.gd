extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var love_letter = $skelebones_love_letter
onready var saveStar = $YSort/SaveStar

const grabbed_love_letter = "GRABBED_LOVE_LETTER"

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"Caves - The Skeleton's House":
			player_position = saveStar.position
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
		"top":
			player_position = topSpawnPoint.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
	if stats.check_bool(grabbed_love_letter):
		remove_letter()

func remove_letter():
	love_letter.queue_free()

func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/SkelebonesHouse.tscn", "top")

func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/TheFlipperRoom.tscn", "top")


func _on_GoSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "A riveting game!!!", 0.03, "2", null, null
		],
		"2" : [
			"TEXT", "It's close, but you think black is in the lead.", 0.03, null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)

const SKELETON_VOICE_PITCH = 0.5
const SKELETON_SPEECH_RATE = 0.06

func _on_LettersSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "It's a letter!", 0.03, [["Read", "l1"], ["Respect Privacy", "better_not"]], null, null
		],
		"l1" : [
			"TEXT", "To my Dearest Friend,", SKELETON_SPEECH_RATE, "l2", null, null, SKELETON_VOICE_PITCH
		],
		"l2" : [
			"TEXT", "HELLO!!! How are you doing?", SKELETON_SPEECH_RATE, "l33", null, null, SKELETON_VOICE_PITCH
		],
		"l33" : [
			"TEXT", "I hope you are doing well! The picture of you tucked away in your\nstudy reading this letter make me happy already.", SKELETON_SPEECH_RATE, "l3", null, null, SKELETON_VOICE_PITCH
		],
		"l3" : [
			"TEXT", "Thanks for having the patience to write letters even though now I'm a skeletal\nspirit that only appears for 20 minutes during the full moon!", SKELETON_SPEECH_RATE, "l4", null, null, SKELETON_VOICE_PITCH
		],
		"l4" : [
			"TEXT", "I wish it were more often, but thems the SKELETON RULES.", SKELETON_SPEECH_RATE, "l5", null, null, SKELETON_VOICE_PITCH
		],
		"l5" : [
			"TEXT", "I very much enjoyed the copy of \"DEADLY AVENGER II\" you send in your last letter.", SKELETON_SPEECH_RATE, "l7", null, null, SKELETON_VOICE_PITCH
		],
		"l7" : [
			"TEXT", "The scene with the bathtub breaking through the roof of the dining car on the train! Unforgettable", SKELETON_SPEECH_RATE, "l9", null, null, SKELETON_VOICE_PITCH
		],
		"l9" : [
			"TEXT", "As for me, whilst in the SKELETAL REALMS, I think I made an important breakthrough! I've written it here:", SKELETON_SPEECH_RATE, "l10", null, null, SKELETON_VOICE_PITCH
		],
		"l10" : [
			"TEXT", "*COMPLEX AND INSCRUTABLE FORMULA*", 0.03, "l11", null, null
		],
		"l11" : [
			"TEXT", "Please check my calculations! I feel almost certain they are in\nerror. But if I am right, then... YOU KNOW WHAT!",
			SKELETON_SPEECH_RATE, "l12", null, null, SKELETON_VOICE_PITCH
		],
		"l12" : [
			"TEXT", "Ever your friend and admirer,\n- S. K. Bones", SKELETON_SPEECH_RATE, "l13", null, null, SKELETON_VOICE_PITCH
		],
		"l13" : [
			"TEXT", "PS- As I finish this letter, I hear a barking outside...\nCould it be... A Puppy???", SKELETON_SPEECH_RATE, "l14", null, null, SKELETON_VOICE_PITCH
		],
		"l14" : [
			"TEXT", "I will go look! Maybe I will have an interesting story for my next letter.", SKELETON_SPEECH_RATE, "end", null, null, SKELETON_VOICE_PITCH
		],
		"end" : [
			"TEXT", "LETTER ENDS",
			0.03, "take", null, null
		],
		"take" : [
			"TEXT", "Hmm... It looks like the skeleton forgot to mail the letter.\nIt has no address, but maybe you could find the recipient?",
			0.03, [["TAKE IT", "takeit"], ["LEAVE IT", "leave"]], null, null
		],
		"takeit" : [
			"TEXT", "You acquire the UNADDRESSED SKELETON LETTER.", 0.03, null, [self, "get_letter"], null
		],
		"leave" : [
			"TEXT", "Are you sure? If you want to take it later, you'll have to read all that text again!", 0.03, [["TAKE IT", "takeit"], ["LEAVE IT", null]], null, null
		],
		"better_not" : [
			"TEXT", "You change your mind... Better not to snoop!", 0.03, null, null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue)

func get_letter():
	stats.world_state[grabbed_love_letter] = true
	stats.inventory_add("skeleton_letter")
	remove_letter()

func _on_ChairSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "What a sturdily constructed chair! Such well-crafted joinery. It fills your heart with joy.", 0.03, null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)

const GOT_SKELE_DRAWER_G = "got_skeledrawerG"
func _on_DrawerSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "Water sausages! Your old friend. The noblest of flowers!", 0.03, "next", null, null
		],
		"next" : [
			"TEXT", "You rummage around in the drawers.", 0.03, null, null, null
		]
	}
	if not stats.check_bool(GOT_SKELE_DRAWER_G):
		stats.world_state[GOT_SKELE_DRAWER_G] = true
		dialogue["findg"] = [
			"TEXT", "You find 10 G!",
			0.03, null
		]
		dialogue["begin"][3] = "findg"
		stats.G += 10
	else:
		dialogue["findg"] = [
			"TEXT", "You find nothing...",
			0.03, null
		]
		dialogue["begin"][3] = "findg"
		
	DialogueHelper.showDialogue(self, dialogue)

func _on_CattailsSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "Water sausages! Your old friend. The noblest of flowers!", 0.03, null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)
