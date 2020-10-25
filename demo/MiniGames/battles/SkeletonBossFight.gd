extends Control

onready var battle_menu = $BattleMenu
onready var nostalgia_points_group = $Points
onready var nostalgia_points_value = $Points/Value

const SKELETON_VOICE_PITCH = 0.5
const SKELETON_SPEECH_RATE = 0.06

var nostalgia_points = 0

var obstacle_map = {
	"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
			"end_scale" : 10 }
}

func increment_nostalgia_points(value=1):
	nostalgia_points += value
	if nostalgia_points > 0:
		nostalgia_points_group.visible = true
		nostalgia_points_value.text = str(nostalgia_points)

func gen_random_round():
	var rows = [
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["***___", 1],
		["_***__", 1],
		["__***_", 1],
		["___***", 1],
		["**__**", 1],
	]
	var num_rows = rand_range(7, 12)
	rounds = []
	for _i in range(num_rows):
		rounds.append(rows[rand_range(0, len(rows))])
	return rounds
	

var rounds = [
	[
		["__*___", 3],
		["______", 1],
		["**____", 1],
		["_**___", 1],
		["__**__", 4],
		["**__**", 5],
	],
	[
		["*****_", 6],
		["_*****", 6],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 3],
		["**__**", 5],
	],
]

var battle_data = {
	"handler" : [self, "noop"],
	"options" : [
		"Smell", "Bark", "Play Dead", "Roll Over"
	]
}


func get_round_info():	
	var round_info = {
		"obstacle_map": obstacle_map,
		"rounds": gen_random_round()
	}
	return round_info

func action_noop(action):
	var text = "You " + action + "...\n"
	battle_menu.show_text(text)

var fetch_item = null
func change_fetch_item(item):
	fetch_item = load(item["image"])

func get_default_item_dialogue(text):
	return {
		"begin" : [
			"TEXT", text,
			SKELETON_SPEECH_RATE, "giveme", null, null, SKELETON_VOICE_PITCH
		],
		"giveme" : [
			"TEXT", "HEHEHEH! Let me have that!",
			SKELETON_SPEECH_RATE, "FETCH", null, null, SKELETON_VOICE_PITCH
		],
		"FETCH" : [
			"TEXT", "Go fetch, puppy!",
			SKELETON_SPEECH_RATE, null, null, null, SKELETON_VOICE_PITCH
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
		"Your Ball":
			dialogue = get_default_item_dialogue("YOUR BALL!")
		"Old Bone":
			dialogue = get_default_item_dialogue("What a shabby old bone... Wonder who lost that?")
			change_fetch_item(_item)
		"Swimming Certification":
			dialogue = get_default_item_dialogue("HEHEHEH... You CHEATER!\nHow'd you get that?")
			change_fetch_item(_item)
		"Flippers":
			dialogue = get_default_item_dialogue("HEHEHEH... So you've already gotten past me?\nAnd we've done this before?")
			change_fetch_item(_item)
		"Skeleton Key":
			dialogue = {
				"begin" : [
					"TEXT", "...I remember that... From a long time ago...",
					SKELETON_SPEECH_RATE, "nostalgia_points", null, null, SKELETON_VOICE_PITCH
				],
				"nostalgia_points" : [
					"TEXT", "It reminds me of... something...",
					SKELETON_SPEECH_RATE, end_if_seen_before("increment", "key"), null, null, SKELETON_VOICE_PITCH
				],
				"increment" : [
					"TEXT", "NOSTALGIA +1",
					SKELETON_SPEECH_RATE, null, [self, "increment_nostalgia_points"], null, SKELETON_VOICE_PITCH
				]
			}
			change_fetch_item(_item)
		_:
			dialogue = get_default_item_dialogue("Heh heh heh...")
			change_fetch_item(_item)
	menu.close_menu()
	battle_menu.call_deferred("show_dialogue", dialogue)

func text_done():
	battle_menu.fetch_game_controller.play("go_to_game")
	battle_menu.launch_fetch_game(get_round_info(), [self, "game_done"], fetch_item)
	fetch_item = null

func game_done():
	battle_menu.fetch_game_controller.play("leave_game")
	battle_menu.animation.play("default")

var battle_impl = {
	"text_done_handler" : [self, "text_done"],
	"item_handler" : [self, "item_noop"],
	"action_handler" : [self, "action_noop"],
	"options" : [
		"smell", "bark", "play dead", "roll over"
	]
}

func _ready():
	Jukebox.play_song("res://tunes/cave/skeleton_battle_smooth.wav")
	battle_menu.init(battle_impl)
