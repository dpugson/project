extends Control

onready var battle_menu = $BattleMenu
onready var animation = $BossSpriteAnimator
onready var stats = PlayerStats
onready var item_registry = ItemRegistry

const SKELETON_VOICE_PITCH = 0.98
const SKELETON_SPEECH_RATE = 0.04

var obstacle_map = {
	"V" : { "scene": preload("res://MiniGames/battles/ninja/VendingMachineObstacle.tscn"), "end_scale" : 7 },
	"G" : { "scene": preload("res://MiniGames/battles/ninja/GlassesBoxObstacle.tscn"), "end_scale" : 10 },
	"P" : { "scene": preload("res://MiniGames/battles/ninja/PalmObstacle.tscn"), "end_scale" : 10 },
	"T" : { "scene": preload("res://MiniGames/battles/ninja/TrashCanObstacle.tscn"), "end_scale" : 10 },
}


func _ready():
	Jukebox.play_song("res://tunes/lab/ninjasong.wav")
	battle_menu.init(battle_impl)

var default_fetch_item = load("res://MiniGames/battles/ninja/NinjaStar.tscn")
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
	times_generated += 1
	return [
		gen_row("P", 1),
		gen_row("G", 1),
		gen_row("V", 1),
		gen_row("T", 1)
	]

func get_round_info():	
	var round_info = {
		"obstacle_map": obstacle_map,
		"rounds": gen_random_round(),
		#"start_text": "DEADLY NINJA ATTACK!!!!",
	}
	return round_info

var smelled = false
var bit = false

var counter = 0
func get_ninja_attack_dialogue(dialogue):
	var options = [
		[
			"TEXT", "DEADLY NINJA TECHNIQUE- THROWING STAR!!!!!!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
		[
			"TEXT", "MEET YOUR DOOM!!!!!!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
		[
			"TEXT", "TAKE THIS!!!!!!!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
		[
			"TEXT", "My aim isn't usually this bad...",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
		[
			"TEXT", "TASTE NINJA STAR!!!!!!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
		[
			"TEXT", "STOP BEING SO DIFFICULT TO HIT!!!!!!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue2", null, null, SKELETON_VOICE_PITCH
		],
	]
	dialogue["ninja_attack_dialogue"] = options[counter % len(options)]
	var options2 = [
		"The ninja THROWS a deadly projectile at you with KILLING INTENT!",
		"The ninja releases his LIFE ENERGY\nand launches a deadly ninjitsu attack!",
		"The ninja LAUNCHES a projectile directly at your HEART!",
	]
	dialogue["ninja_attack_dialogue2"] = [
			"TEXT", options2[counter % len(options2)],
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue3", null, null
	]
	dialogue["ninja_attack_dialogue3"] = [
			"TEXT", "...and misses by " + str(floor(rand_range(1, 4))) + " feet!!",
			SKELETON_SPEECH_RATE, null, null, null
	]
	counter += 1
	
func action_noop(action):
	var dialogue = null
	match action.to_lower():
		"smell":
			if !bit:
				dialogue = {
						"begin" : [
							"TEXT", "You attempt to smell the Ninja, but he dodges!",
							SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null
						],
					}
			else:
				smelled = true
				dialogue = {
						"begin" : [
							"TEXT", "You successfully smell the old ninja...",
							SKELETON_SPEECH_RATE, "2", null, null
						],
						"2" : [
							"TEXT", "Smells...",
							SKELETON_SPEECH_RATE, "3", null, null
						],
						"3" : [
							"TEXT", "BAD!!!!!!!",
							SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null
						],
					}
		"bite":
			if bit:
				dialogue = {
						"begin" : [
							"TEXT", "You attempt to bite the ninja again...",
							SKELETON_SPEECH_RATE, "next", null, null
						],
						"next" : [
							"TEXT", "HE'S APPLIED ANTI-BITE SPRAY!!!!",
							SKELETON_SPEECH_RATE, "2", null, null
						],
						"2" : [
							"TEXT", "TASTES... BAD!!!!",
							SKELETON_SPEECH_RATE, "next2", null, null
						],
						"next2" : [
							"TEXT", "Fufufufu!!! Foolish puppy... I have learned your tricks!!!",
							SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null, SKELETON_VOICE_PITCH
						],
					}
			else:
				bit = true
				dialogue = {
						"begin" : [
							"TEXT", "OW!!!",
							SKELETON_SPEECH_RATE, "next3", null, null
						],
						"next3" : [
							"TEXT", "You successfully bite the Ninja! NINJA SUFFERS -5 TO AGILITY",
							SKELETON_SPEECH_RATE, "next2", null, null
						],
						"next2" : [
							"TEXT", "You are proving yourself to be a worthy opponent!",
							SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null, SKELETON_VOICE_PITCH
						],
					}
				
		"bark":
			dialogue = {
					"begin" : [
						"TEXT", "Ninja-technique - IGNORE BARK!",
						SKELETON_SPEECH_RATE, "increment", null, null, null, SKELETON_VOICE_PITCH
					],
					"increment" : [
						"TEXT", "The ninja ignored your bark... Your attack has no effect.",
						SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null, null
					]
				}
		"throw up":
			battle_menu.set_decision_stuff_visible(false)
			#smelled = true
			if smelled:
				done = true
				vom()
#				dialogue = {
#						"begin" : [
#							"TEXT", "YOU VOMIT COPIOUSLY!",
#							SKELETON_SPEECH_RATE, null, null, null
#						]
#					}
#				battle_menu.call_deferred("show_dialogue", dialogue)
				return
			else:
				dialogue = {
						"begin" : [
							"TEXT", "You try to throw up!",
							SKELETON_SPEECH_RATE, "next", null, null
						],
						"next" : [
							"TEXT", "It doesn't work... You're an artist!\nYou need inspiration.",
							SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null
						],
					}
	get_ninja_attack_dialogue(dialogue)
	battle_menu.call_deferred("show_dialogue", dialogue)

func vom():
	animation.play("vom2")

func pause_music():
	Jukebox.stop_it()

func vom_finished():
	really_done = true
	var dialogue = {
		"begin" : [
			"TEXT", "...",
			SKELETON_SPEECH_RATE, null, null, null
		]
	}
	battle_menu.call_deferred("show_dialogue", dialogue)

func get_default_item_dialogue(text, item_name):
	return {
		"begin" : [
			"TEXT", text,
			SKELETON_SPEECH_RATE, "giveme", null, null, SKELETON_VOICE_PITCH
		],
		"giveme" : [
			"TEXT", "Don't you know ninjas can use anything as weapon?",
			SKELETON_SPEECH_RATE, "FETCH", null, null, SKELETON_VOICE_PITCH
		],
		"FETCH" : [
			"TEXT", item_name + " will be your downfall!",
			SKELETON_SPEECH_RATE, "ninja_attack_dialogue", null, null, SKELETON_VOICE_PITCH
		]
	}

var nostalgia_bank = {}
func end_if_seen_before(target, key):
	if nostalgia_bank.get(key, null) == null:
		nostalgia_bank[key] = true
		return target
	else:
		return null

func item_noop(menu, _label, _item, _prev):
	battle_menu.animation.play("default")
	var dialogue = null
	match _item.name:
		"Swimming Certification":
			dialogue = get_default_item_dialogue("Your credentials won't save you, fool!!!", _item.name)
			change_fetch_item(_item)
		"Flippers":
			dialogue = get_default_item_dialogue("Wh-where did you get these??? Those belonged to an old rival...", _item.name)
			change_fetch_item(_item)
		"Skeleton Key":
			dialogue = get_default_item_dialogue("A key symbolizing death... How fitting!", _item.name)
			change_fetch_item(_item)
		_:
			dialogue = get_default_item_dialogue("What is this???", _item.name)
			change_fetch_item(_item)
	menu.close_menu()
	get_ninja_attack_dialogue(dialogue)
	battle_menu.call_deferred("show_dialogue", dialogue)

var done = false
var really_done = false
func text_done():
	if really_done:
		Transition.go_to("res://Levels/1.0 - Lab/labhallway.tscn", "post_battle")
	elif done:
		vom()
	else:
		battle_menu.fetch_game_controller.play("go_to_game")
		battle_menu.launch_fetch_game(get_round_info(), [self, "game_done"], fetch_item, used_default)
		fetch_item = default_fetch_item
		used_default = true

func game_done():
	battle_menu.fetch_game_controller.play("leave_game")
	battle_menu.animation.play("default")

var battle_impl = {
	"text_done_handler" : [self, "text_done"],
	"item_handler" : [self, "item_noop"],
	"action_handler" : [self, "action_noop"],
	"options" : [
		 "smell", "bite", "bark", "throw up"
	],
}
