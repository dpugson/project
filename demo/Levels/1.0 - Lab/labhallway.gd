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

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
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
	pass # Replace with function body.

func continue_cutscene_in_breakroom():
	Transition.go_to("res://Levels/1.0 - Lab/BreakRoom.tscn", "emerge_cutscene")

func _on_laboratorydoor_seen(_obj):
	var dialogue = {
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


func _on_glassesbox_seen(_obj):
	pass # Replace with function body.
