extends Node2D

onready var animated_sprite = $AnimatedSprite
onready var stats = PlayerStats
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

var NINJA_SPEECH_SPEED = 0.04
var NINJA_PITCH = .98

var NINJA_STATE_KEY = "NINJA_STATE_KEY"

# Called when the node enters the scene tree for the first time.
func _ready():
	#if not stats.world_state.has("NINJA_STATE"):
	stats.world_state[NINJA_STATE_KEY] = "INIT"

func look_at_you():
	animated_sprite.animation = "LookingAtYou"

func back_to_wall():
	animated_sprite.animation = "FacingWall"

var num_bothers = 0

func handle_init_state():
	match num_bothers:
		0:
			num_bothers += 1
			return {
				"begin" : [
					"TEXT", "...", NINJA_SPEECH_SPEED, 
					"begin2", null, null, null
				], 
				"begin2" : [
					"TEXT", "(Have I been detected???)", NINJA_SPEECH_SPEED, 
					"begin3", null, null, NINJA_PITCH
				],
				"begin3" : [
					"TEXT", "(No... Impossible. My disguise is perfect.)", NINJA_SPEECH_SPEED, 
					null, null, null, NINJA_PITCH
				], 
			}
		1:
			num_bothers += 1
			return {
				"begin" : [
					"TEXT", "...", NINJA_SPEECH_SPEED, 
					null, null, null, null
				]
			}
		2:
			num_bothers += 1
			return {
				"begin" : [
					"TEXT", "Go away! No one's here!", NINJA_SPEECH_SPEED, 
					null, [self, "look_at_you"], null, NINJA_PITCH
				]
			}
		3:
			num_bothers += 1
			return {
				"begin" : [
					"TEXT", "Can't you see I'm very busy?", NINJA_SPEECH_SPEED, 
					null, [self, "look_at_you"], null, NINJA_PITCH
				],
				"2" : [
					"TEXT", "(The puppy is persistent... Not good.)", NINJA_SPEECH_SPEED, 
					null, [self, "back_to_wall"], null, NINJA_PITCH
				]
			}
		_:
			stats.world_state[NINJA_STATE_KEY] = "GIVE_DRINK_MISSION"
			return {
				"begin" : [
					"TEXT", "Shoo!!!", NINJA_SPEECH_SPEED, 
					null, [self, "look_at_you"], null, NINJA_PITCH
				]
			}

func get_5_g():
	stats.G += 5

func garbage_mission():
	stats.world_state[NINJA_STATE_KEY] = "GARBAGE_MISSION"

func give_out_drink_mission():
	stats.world_state[NINJA_STATE_KEY] = "DRINK_MISSION"
	return {
		"begin" : [
			"TEXT", "...", NINJA_SPEECH_SPEED, 
			"begin2", null, null, null
		],
		"begin2" : [
			"TEXT", "How about we make a deal...\nI give you 5 G to go get yourself a soda pop...", NINJA_SPEECH_SPEED, 
			"22", [self, "look_at_you"], null, NINJA_PITCH
		],
		"22" : [
			"TEXT", "And you pretend you never saw this old ninja.", NINJA_SPEECH_SPEED, 
			[
				["HMM... OK!", "ok"],
				["I'M NOT THIRSTY!", "not"]
			], null, null, NINJA_PITCH
		],
		"ok" : [
			"TEXT", "You gain 5 G.", NINJA_SPEECH_SPEED, 
			"4", [self, "get_5_g"], null, null
		],
		"4" : [
			"TEXT", "This never happened...", NINJA_SPEECH_SPEED, 
			null, null, null, NINJA_PITCH
		],
		"not" : [
			"TEXT", "Oh. Umm.... Well....", NINJA_SPEECH_SPEED, 
			"5", null, null, NINJA_PITCH
		],
		"5" : [
			"TEXT", "There's tons of more interesting things\nto do here than bother an old man...", NINJA_SPEECH_SPEED, 
			"52", [self, "look_at_you"], null, NINJA_PITCH
		],
		"52" : [
			"TEXT", "Why don't you be a good boy and go play with\nthe garbage in that garbage can?", NINJA_SPEECH_SPEED, 
			"56", [self, "garbage_mission"], null, NINJA_PITCH
		],
		"56" : [
			"TEXT", "Yes, go eat some garbage and forget you ever saw this old ninja.", NINJA_SPEECH_SPEED, 
			null, null, null, NINJA_PITCH
		]
	}

func handle_drink_mission():
	return {
		"begin" : [
			"TEXT", "...", NINJA_SPEECH_SPEED, 
			"2", null, null, NINJA_PITCH
		],
		"2" : [
			"TEXT", "Come on! Go get your soda pop!", NINJA_SPEECH_SPEED, 
			null, [self, "look_at_you"], null, NINJA_PITCH
		],
	}

func handle_garbage_mission():
	return {
		"begin" : [
			"TEXT", "Well, go on! Go eat some delicious garbage!", NINJA_SPEECH_SPEED, 
			null,  [self, "look_at_you"], null, NINJA_PITCH
		]
	}

func handle_got_drink():
	return {
		"begin" : [
			"TEXT", "Did you get your soda pop? Yes? SO NOW LET ME BE!!!", NINJA_SPEECH_SPEED, 
			"begin1", [self, "look_at_you"], null, NINJA_PITCH
		],
		"begin1" : [
			"TEXT", "There's tons of more interesting things\nto do here than bother an old man...", NINJA_SPEECH_SPEED, 
			"2", [self, "look_at_you"], null, NINJA_PITCH
		],
		"2" : [
			"TEXT", "Why don't you be a good boy and go play with\nthe garbage in that garbage can?", NINJA_SPEECH_SPEED, 
			"6", [self, "garbage_mission"], null, NINJA_PITCH
		],
		"6" : [
			"TEXT", "Yes, go eat some garbage and forget you ever saw this old ninja.", NINJA_SPEECH_SPEED, 
			null, null, null, NINJA_PITCH
		]
	}

func garbage_confrontation(confrontation_option_text):
	return {
		"begin" : [
			"TEXT", "...", NINJA_SPEECH_SPEED, 
			[["Confront", "c"], ["Ignore", null]], null, null, NINJA_PITCH
		],
		"c": [
			"TEXT", "(Have you saved? I might save now, if I were you...)", NINJA_SPEECH_SPEED, 
			[["No", null], ["Yes", "c2"]], null, null, NINJA_PITCH
		],
		"c2" : [
			"TEXT", "What is it puppy?", NINJA_SPEECH_SPEED, 
			[[confrontation_option_text, "6"]], [self, "look_at_you"], null, NINJA_PITCH
		],
		"6" : [
			"TEXT", "(This puppy is relentless... If this continues,\nmy mission is in danger...)", NINJA_SPEECH_SPEED, 
			"7", [self, "back_to_wall"], null, NINJA_PITCH
		],
		"7" : [
			"TEXT", "(I have no choice...)", NINJA_SPEECH_SPEED, 
			"8", null, null, NINJA_PITCH
		],
		"8" : [
			"TEXT", "Puppy... You leave me no choice...", NINJA_SPEECH_SPEED, 
			"9", [self, "look_at_you"], null, NINJA_PITCH
		],
		"9" : [
			"TEXT", "Prepare... TO DIE!!!!", NINJA_SPEECH_SPEED, 
			null, null, null, NINJA_PITCH
		],
	}

func garbage_righteous():
	return garbage_confrontation("You've besmirched my puppy honor!!!")

func garbage_indignant():
	return garbage_confrontation("There's no garbage!!! You lied to me!!!")

func get_ninja_dialogue():
	match stats.world_state[NINJA_STATE_KEY]:
		"INIT":
			return handle_init_state()
		"GIVE_DRINK_MISSION":
			return give_out_drink_mission()
		"DRINK_MISSION":
			return handle_drink_mission()
		"GOT_DRINK":
			return handle_got_drink()
		"GARBAGE_MISSION":
			return handle_garbage_mission()
		"GARBAGE_RIGHTEOUS":
			return garbage_righteous()
		"GARBAGE_INDIGNANT":
			return garbage_indignant()

func _on_SeenBox_seen(_obj):
	DialogueHelper.showDialogue(self, get_ninja_dialogue(), false, [self, "back_to_wall"])
