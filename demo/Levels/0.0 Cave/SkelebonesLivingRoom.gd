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
			"TEXT", "It's a letter!", 0.03, [["Read", "l2"], ["Respect Privacy", "better_not"]], null, null
		],
		"l2" : [
			"TEXT", "TO THE EDITORS OF PUZZLES WEEKLY,",
			SKELETON_SPEECH_RATE, "l3", null, null, SKELETON_VOICE_PITCH
		],
		"l3" : [
			"TEXT", "I READ WITH DISPLEASURE YOUR RECENT ARTICLE\n'BOX PUZZLES: PLAYED OUT?'.",
			SKELETON_SPEECH_RATE, "l4", null, null, SKELETON_VOICE_PITCH
		],
		"l4" : [
			"TEXT", "INCORRECT!!! SOKOBAN PUZZLES ARE ALWAYS IN STYLE!!!\nLET ME ENUMERATE THEIR MANY POSITIVE ATTRIBUTES!",
			SKELETON_SPEECH_RATE,  "l5", null, null, SKELETON_VOICE_PITCH
		],
		"l5" : [
			"TEXT", "It goes on like this for five more pages...",
			0.03, null, null, null, 
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
			"TEXT", "Water sausages! Your old friend. The noblest of flowers!", 0.03,
			[
				["Rummage around in the drawers", "next"],
				["Cool", null]
			], null, null
		],
		"next" : [
			"TEXT", "You rummage around in the drawers...", 0.03, null, null, null
		]
	}
	if not stats.check_bool(GOT_SKELE_DRAWER_G):
		stats.world_state[GOT_SKELE_DRAWER_G] = true
		dialogue["next"] = [
			"TEXT", "You find 10 G!",
			0.03, null
		]
		stats.G += 10
	else:
		dialogue["next"] = [
			"TEXT", "No more G...",
			0.03, null
		]
		
	DialogueHelper.showDialogue(self, dialogue)
