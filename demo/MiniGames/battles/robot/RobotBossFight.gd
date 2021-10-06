extends Control

onready var battle_menu = $BattleMenu
onready var animation = $BossSpriteAnimator
onready var stats = PlayerStats
onready var item_registry = ItemRegistry

const SKELETON_VOICE_PITCH = 2
const SKELETON_SPEECH_RATE = 0.05

var in_final_stage = false

enum {
	LICK_GAME,
	FETCH_GAME
}
var next = null

var obstacle_map = {
	"*" : { "scene": preload("res://MiniGames/battles/ninja/PageObstacle.tscn"), "end_scale" : 5 },
}

var battle_impl = {
	"text_done_handler" : [self, "text_done"],
	"item_handler" : [self, "item_noop"],
	"action_handler" : [self, "handle_action"],
	"options" : [
		"What's up?",
		"lick to cheer up"
	],
}

var curr_battle_stage = null

var done = false

func _ready():
	Jukebox.play_song("res://tunes/lab/labrat_lofi.wav")
	battle_menu.init(battle_impl)
	set_battle_stage("one")
	#set_battle_stage("four")

func set_battle_stage(stage):
	curr_battle_stage = stage
	var battle_obj = battle_stuff()[curr_battle_stage]
	var options = battle_obj["options"]
	battle_impl["options"] = options
	battle_menu.init(battle_impl)

func handle_action(action):
	var battle_obj = battle_stuff()[curr_battle_stage]
	var result = battle_obj["results"][action]
	var raw_dialogue = result["dialogue"]
	set_battle_stage(result["next"])
	var dialogue = {}
	var index = 0
	var pitch = result.get("pitch", null)
	for line in raw_dialogue:
		var dialogue_key = str(index)
		if index == 0:
			dialogue_key = "begin"
		
		var next_dialogue = str(index + 1)
		if index == len(raw_dialogue) - 1:
			next_dialogue = null
		dialogue[dialogue_key] = [
			"TEXT", line, SKELETON_SPEECH_RATE, next_dialogue, null, null, pitch
		]
		index += 1
	next = result["game"]
	battle_menu.call_deferred("show_dialogue", dialogue)

func battle_stuff():
	return {
		"one" : {
			"options" : [ "What's up?" ],
			"results" : {
				"What's up?" : {
					"dialogue" : [
						"I'm never going to do it, am I?",
						"I'm never going to finish my thesis...",
						"I've been working in this Puzzle Studies lab\nfor so long they've made me the mascot...",
						"...but I feel like I haven't gotten any closer\nto really getting anything done.",
						"UGHH!! MY PAPER IS SO BAD!!!!",
						"Better throw this piece of garbage away..."
					],
					"next" : "two",
					"game" : FETCH_GAME,
					"pitch" : SKELETON_VOICE_PITCH
				}
			},
		},
		"two" : {
			"options" : [ "Well, what do you have left to do?" ],
			"results" : {
				 "Well, what do you have left to do?" : {
					"dialogue" : [
						"Ummm!!!! Well!!! LOTS!!!!",
						"Like, uh...",
						"I haven't found the right font!",
						"And I've only triple checked my figures!!!\nQuadruple would be better! Quintuple!",
						"I just need to rewrite the whole thing!!!",
						"IT'S GARBAGE",
						"I'M GARBAGE",
					],
					"next" : "three",
					"game" : FETCH_GAME,
					"pitch" : SKELETON_VOICE_PITCH
				}
			}
		},
		"three" : {
			"options" : [ "...sounds like you're done to me!" ],
			"results" : {
				 "...sounds like you're done to me!" : {
					"dialogue" : [
						"Whh-",
						"But it's so terrible!!!!", "It's rubbish!!!!!",
						"I SUCK",
						"AAAAAAAAAAAAHHHH",
						"AAAGHHHHH",
						"AAAAAHHHHH",
						"AAAAGHGHGHHHHHH",
						"AAAAGAAAAAAAAAAAAAAAAAAAAAAAAHGHGHHHHHH",
						"AAAH",
						"A"
					],
					"next" : "four",
					"game" : FETCH_GAME,
					"pitch" : SKELETON_VOICE_PITCH
				}
			}
		},
		"four" : {
			"options" : [ "Lick!!!!"],
			"results" : {
				"Lick!!!!" : {
					"dialogue" : [
						"You decide this robot needs to be CHEERED UP.",
						"Your doggo instincts kick in.",
						"LICK MODE ACTIVATED!",
						"DOGGO KISSES"
					],
					"next" : "four",
					"game" : LICK_GAME
				}
			}
		},
	}

var default_fetch_item = load("res://sprites/L2_lab/thesis.png")
var fetch_item = default_fetch_item
var used_default = true
func change_fetch_item(item):
	fetch_item = load(item["image"])
	used_default = false

func gen_row(L, time):
	var left = rand_range(0, 6)
	var right = 6 - left
	return ["_".repeat(left) + L + "_".repeat(right), time]

var times_generated = 0
func gen_random_round():
	var rows = [
		["*_*_*_", 0.5],
		["______", 0.5],
		["_*_*_*", 0.5],
		["_*__*_", 0.5],
		["*____*", 0.5],
		["*_*___", 0.5],
		["_*_*__", 0.5],
		["___*_*", 0.5],
		["__*_*_", 0.5],
		["___*_*", 0.5],
		["*_*__*", 0.5],
		["_*_*__", 0.5],
		["_*_*_*", 0.5],
		["__****", 0.5],
		["**__**", 0.5],
	]
	var num_rows = rand_range(5 - times_generated, 14 - times_generated)
	var rounds = []
	for _i in range(num_rows):
		rounds.append(rows[rand_range(0, len(rows))])
	#times_generated += 1
	#times_generated = min(4, times_generated)
	return rounds

func get_round_info():	
	var round_info = {
		"obstacle_map": obstacle_map,
		"rounds": gen_random_round(),
	}
	return round_info

func get_default_item_dialogue(text, _item_name):
	return {
		"begin" : [
			"TEXT", text,
			SKELETON_SPEECH_RATE, "giveme", null, null, null
		],
		"giveme" : [
			"TEXT", "No response...",
			SKELETON_SPEECH_RATE, "null", null, null, null
		],
		"null" : [
			"TEXT", "I don't think any of your items are going\nto be much help...",
			SKELETON_SPEECH_RATE, null, null, null, null
		],
	}


func item_noop(menu, _label, _item, _prev):
	battle_menu.animation.play("default")
	var dialogue = null
	match _item.name:
		_:
			dialogue = get_default_item_dialogue("You present the item to the sad robot...", _item.name)
			#change_fetch_item(_item)
	menu.close_menu()
	next = FETCH_GAME
	battle_menu.call_deferred("show_dialogue", dialogue)


func game_done():
	if in_final_stage:
		battle_menu.fetch_game_controller.play("go_to_game")
		battle_menu.launch_lick_game([self, "lick_game_done"])
		return
	battle_menu.fetch_game_controller.play("leave_game")
	battle_menu.animation.play("default")

func lick_game_done(_won):
	in_final_stage = true
	if _won:
		stats.set_bool("alllabpuzzlesdone")
		queue_free()
		end_game()
	else:
#		battle_menu.fetch_game_controller.play("leave_game")
#		battle_menu.animation.play("default")
#		battle_menu.fetch_game_controller.play("go_to_game")
		battle_menu.launch_fetch_game(get_round_info(), [self, "game_done"], fetch_item)

func end_game():
	stats.world_state["BEAT_ROBOT"] = true
	Transition.go_to("res://Levels/1.0 - Lab/labpuzzleroom3.tscn", "beat_game")

func text_done():
	match next:
		LICK_GAME:
			battle_menu.fetch_game_controller.play("go_to_game")
			battle_menu.launch_lick_game([self, "lick_game_done"], -1) #infinite length
		FETCH_GAME:
			battle_menu.fetch_game_controller.play("go_to_game")
			battle_menu.launch_fetch_game(get_round_info(), [self, "game_done"], fetch_item)
		_:
			battle_menu.fetch_game_controller.play("go_to_game")
			battle_menu.launch_fetch_game(get_round_info(), [self, "game_done"], fetch_item)
