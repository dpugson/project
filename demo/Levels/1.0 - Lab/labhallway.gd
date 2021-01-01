extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bathroomSP = $BathroomDoorSP
onready var labSP = $LabDoorSP
onready var breakRoomSP = $BreakRoomDoorSP
onready var animation = $AnimationPlayer
onready var camera = $PuppyCamera
onready var robot = $Robot
onready var save_star = $YSort/SaveStar
onready var postBattleSP = $PostBattleSP
onready var ninja = $ninja
onready var ninja_talk_box = $ninja/SeenBox/CollisionShape2D
onready var ninja_collision = $ninja/StaticBody2D/CollisionShape2D
onready var throwup = $throwup2
onready var wallet_animation = $YSort/wallet/wallet_animation
onready var wallet = $YSort/wallet
onready var door = $labdoor

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const NINJA_GONE = "NINJA_GONE_FROM_HALLWAY"
const WALLET_DROPPED = "WALLET_DROPPED"
const DOOR_UNLOCKED = "DOOR_UNLOCKED"

func _ready():
	throwup.visible = false
	if stats.check_bool(NINJA_GONE):
		ninja.visible = false
		ninja_talk_box.disabled = true
		ninja_collision.disabled = true
	if stats.check_bool(WALLET_DROPPED):
		wallet_animation.play("dropped")
	if stats.check_bool(DOOR_UNLOCKED):
		door.queue_free()
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"The Lab - Back Hallway":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = save_star.position
			orientation = Vector2.DOWN
		"bathroom":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bathroomSP.position
			orientation = Vector2.DOWN
		"lab":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = labSP.position
			orientation = Vector2.DOWN
		"break_room":
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = breakRoomSP.position
			orientation = Vector2.DOWN
		"post_battle":
			player.cutscene_mode = true
			Jukebox.stop()
			player_position = postBattleSP.position
			orientation = Vector2.UP
			animation.play("ninja_battle_finished")
		"emerge_cutscene":
			Jukebox.play_song("res://tunes/lab/sleepypuppy.wav")
			player.queue_free()
			animation.play("walk_across")
			var transform = RemoteTransform2D.new()
			transform.remote_path = "../../PuppyCamera"
			robot.add_child(transform)
			return
		_:
			Jukebox.play_song("res://tunes/lab/background_science.wav")
			player_position = bathroomSP.position
			orientation = Vector2.DOWN
			
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_BathroomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/Bathroom.tscn", "door")

func _on_BreakRoomTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/BreakRoom.tscn", "door")

func _on_LabTZ_transition_triggered():
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom1.tscn", "bottom")

func continue_cutscene_in_breakroom():
	Transition.go_to("res://Levels/1.0 - Lab/BreakRoom.tscn", "emerge_cutscene")

func _on_laboratorydoor_seen(_obj):
	var dialogue
	if stats.inventory_get("ninja_wallet") >= 1:
		dialogue = {
			"begin" : [
				"TEXT", "LAB IDENTIFICATION VERIFIED! GRANTING ACCESS.",
				0.03, null
			]
		}
		stats.world_state[DOOR_UNLOCKED] = true
		door.queue_free()
	else:
		dialogue = {
			"begin" : [
				"TEXT", "ERROR: ACCESS DENIED. VALID LAB IDENTIFICATION REQUIRED.",
				0.03, null
			]
		}
	DialogueHelper.showDialogue(self, dialogue)

func go_to_righteous_garbage_state():
	stats.world_state["NINJA_STATE_KEY"] = "GARBAGE_RIGHTEOUS"

func go_to_indignant_garbage_state():
	stats.world_state["NINJA_STATE_KEY"] = "GARBAGE_INDIGNANT"

func looked_in_garbage():
	stats.world_state["LOOKED_IN_GARBAGE_ON_OWN"] = true

func already_looked_in_garbage_comment():
	if stats.check_bool("LOOKED_IN_GARBAGE_ON_OWN"):
		return "true"
	else:
		return null

func _on_wastebin_seen(_obj):
	var get_dialogue = {
		"begin" : [
			"TEXT", "Look in the garbage?",
			0.03, [["yes", "yes"], ["no", "no"]]
		],
		"yes" : [
			"TEXT", "It's empty... But the delicious smell of garbage remains!",
			0.03, null, [self, "looked_in_garbage"]
		],
		"no" : [
			"TEXT", "You refrain from digging in the garbage.\nYou are filled with a feeling of righteousness!",
			0.03, "no2"
		],
		"no2" : [
			"TEXT", "Never shall this Good Boy Snoot\nDescend in nasty garbage to root!",
			0.03, null
		],
	}
	if stats.world_state["NINJA_STATE_KEY"] == "GARBAGE_MISSION":
		get_dialogue = {
			"begin" : [
				"TEXT", "Look in the garbage?",
				0.03, [["yes", "yes"], ["no", "no"]]
			],
			"yes" : [
				"TEXT", "It's empty... Where is the delicious garbage?\nYOU'VE BEEN LIED TO!!!",
				0.03, null, [self, "go_to_indignant_garbage_state"]
			],
			"no" : [
				"TEXT", "No way!!! There's no way some stranger\nis gonna to make you dig in garbage!",
				0.03, "no2", [self, "go_to_righteous_garbage_state"]
			],
			"no2" : [
				"TEXT", "You're a Good Boy!!!",
				0.03, "no3"
			],
			"no3" : [
				"TEXT", "Never shall this Good Boy Snoot\nDescend in nasty garbage to root!",
				0.03, already_looked_in_garbage_comment()
			],
			"true" : [
				"TEXT", "(even though you did dig around in the garbage earlier......)",
				0.03, null
			]
		}
#	var empty_dialogue = {
#		"begin" : [
#			"TEXT", "It's empty, but the delicious smell of garbage remains.",
#			0.03, null
#		],
#	}
#	var dialogue = empty_dialogue
#	if not stats.check_bool(GOT_IT):
#		stats.world_state[GOT_IT] = true
#		dialogue = get_dialogue
#		stats.inventory_add("leftovers")
	var dialogue = get_dialogue
	DialogueHelper.showDialogue(self, dialogue)

func advance_soda_quest_if_relevant():
	if stats.world_state["NINJA_STATE_KEY"] == "DRINK_MISSION":
		stats.world_state["NINJA_STATE_KEY"] = "GOT_DRINK"

var bought_drink_after_ninja_mission
func buy_yum():
	print(stats.G)
	if stats.G < 5:
		return "You don't have enough G..."
	else:
		stats.G -= 5;
		stats.inventory_add("yum_juice")
		advance_soda_quest_if_relevant()
		return "You receive 1 YUM JUICE."

func buy_devil_cola():
	if stats.G < 5:
		return "You don't have enough G..."
	else:
		stats.G -= 5;
		stats.inventory_add("devil_cola")
		advance_soda_quest_if_relevant()
		return "You receive 1 DEVIL COLA."

func buy_canned_pizza():
	if stats.G < 5:
		return "You don't have enough G..."
	else:
		stats.G -= 5;
		stats.inventory_add("canned_pizza")
		advance_soda_quest_if_relevant()
		return "You receive 1 CANNED PIZZA."

func get_buy_prompt():
	return "ITEMS AVAILABLE FOR PURCHASE (You have " + str(stats.G) + "G)"

func _on_sodamachine_seen(_obj):
	var pillow_dialogue = {
		"begin" : [
			"ACTION", [self, "get_buy_prompt"],
			0.03, [
				["YUM JUICE - 5G", "yum"],
				["DEVIL COLA - 5G", "devil"],
				["CANNED PIZZA - 5G", "pizza"],
				["NO THANKS", null]
			]
		],
		"yum" : [
			"ACTION", [self, "buy_yum"],
			0.03, null
		],
		"devil" : [
			"ACTION", [self, "buy_devil_cola"],
			0.03, null
		],
		"pizza" : [
			"ACTION", [self, "buy_canned_pizza"],
			0.03, null
		],
	}
	DialogueHelper.showDialogue(self, pillow_dialogue)

var NINJA_SPEECH_SPEED = 0.04
var NINJA_PITCH = .98
func not_paid_enough_for_this():
	var dialogue = {
		"begin" : [
			"TEXT", "...", NINJA_SPEECH_SPEED, 
			"2", null, null, NINJA_PITCH
		],
		"2" : [
			"TEXT", "Ok, I am NOT being payed enough for this.", NINJA_SPEECH_SPEED, 
			null, null, null, NINJA_PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "disappear_ninja"])

func disappear_ninja():
	stats.world_state[NINJA_GONE] = true
	ninja.disappear([self, "drop_wallet"])
	throwup.visible = true

func drop_wallet(_ignore):
	wallet_animation.play("drop")
	stats.world_state[WALLET_DROPPED] = true

func wallet_dropped():
	player.cutscene_mode = false
	Jukebox.play_song("res://tunes/lab/background_science.wav")

func _on_glassesbox_seen(_obj):
	pass # Replace with function body.

func _on_WalletSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "He dropped his wallet!", 0.03, 
			"2", null, null
		],
		"2" : [
			"TEXT", "Take?", NINJA_SPEECH_SPEED, 
			[["YES", "yes"], ["NO", null]], null, null
		],
		"yes" : [
			"TEXT", "FINDERS KEEPERS!", NINJA_SPEECH_SPEED, 
			"gain", [self, "get_wallet"], null
		],
		"gain" : [
			"TEXT", "You gain 1 WALLET.", NINJA_SPEECH_SPEED, 
			"keycard", null, null
		],
		"keycard" : [
			"TEXT", "The only thing in it is a SECURITY CLEARANCE CARD.", NINJA_SPEECH_SPEED, 
			null, null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false)

func get_wallet():
	stats.inventory_add("ninja_wallet")
	wallet.queue_free()
