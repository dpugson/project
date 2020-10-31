extends Control

onready var battle_menu = $BattleMenu
onready var nostalgia_points_group = $Points
onready var nostalgia_points_value = $Points/Value
onready var animation = $SkeletonAnimator
onready var dog = $Dog
onready var skull = $SkeletonBossSprite/sk_head
onready var dog_end_position = $DogEndPosition
onready var stats = PlayerStats

const SKELETON_VOICE_PITCH = 0.5
const SKELETON_SPEECH_RATE = 0.06

const MAX_NOSTALGIA = 4
var nostalgia_points = 0

var obstacle_map = {
	"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
			"end_scale" : 10 }
}

func increment_nostalgia_points(value=1):
	nostalgia_points += value
	if nostalgia_points > 0:
		if nostalgia_points >= MAX_NOSTALGIA:
			nostalgia_points_value.text = "MAX"
		else:
			nostalgia_points_value.text = str(nostalgia_points)

var times_generated = 0
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
		["***___", 2],
		["_***__", 2],
		["__***_", 2],
		["___***", 2],
		["**__**", 2],
	]
	var num_rows = rand_range(4 + times_generated, 9 + times_generated)
	var rounds = []
	for _i in range(num_rows):
		rounds.append(rows[rand_range(0, len(rows))])
	times_generated += 1
	return rounds

var battle_data = {
	"handler" : [self, "noop"],
	"options" : [
		"Smell", "Bark",  "Roll Over", "Play Dead",
	]
}


func get_round_info():	
	var round_info = {
		"obstacle_map": obstacle_map,
		"rounds": gen_random_round()
	}
	return round_info
	
var play_dead_counter = 0

func get_play_dead_dialogue():
	play_dead_counter += 1
	match play_dead_counter:
		1:
			return {
					"begin" : [
						"TEXT", "HAHAHAHA!!!",
						SKELETON_SPEECH_RATE, "giveme", null, null, SKELETON_VOICE_PITCH
					],
					"giveme" : [
						"TEXT", "LOL! IS THAT SUPPOSED TO BE ME??",
						SKELETON_SPEECH_RATE, "increment", null, null, SKELETON_VOICE_PITCH
					],
					"increment" : [
						"TEXT", "DISTRACTION +1",
						SKELETON_SPEECH_RATE, null, [self, "increment_nostalgia_points"], null, SKELETON_VOICE_PITCH
					],
				}
		2:
			return {
					"begin" : [
						"TEXT", "HEHEHEH, NEVER GETS OLD",
						SKELETON_SPEECH_RATE, "giveme", null, null, SKELETON_VOICE_PITCH
					],
					"giveme" : [
						"TEXT", "HEH",
						SKELETON_SPEECH_RATE, "increment", null, null, SKELETON_VOICE_PITCH
					],
					"increment" : [
						"TEXT", "DISTRACTION +1",
						SKELETON_SPEECH_RATE, null, [self, "increment_nostalgia_points"], null, SKELETON_VOICE_PITCH
					],
			}
		_:
			return {
				"begin" : [
						"TEXT", "HEHEH",
						SKELETON_SPEECH_RATE, null, null, null, SKELETON_VOICE_PITCH
				],
			}


func grab_skull():
	battle_menu.queue_free()
	animation.stop()
	var tween = Tween.new()
	dog.add_child(tween)
	tween.interpolate_property(
		dog,
		"global_position",
		dog.global_position,
		skull.global_position,
		1
	)
	tween.connect("tween_completed", self, "grab_skull_part2", [tween])
	tween.start()

func grab_skull_part2(_a, _b, old_tween):
	old_tween.queue_free()
	var tween = Tween.new()
	dog.add_child(tween)
	tween.interpolate_property(
		dog,
		"global_position",
		dog.global_position,
		dog_end_position.global_position,
		1
	)
	tween.interpolate_property(
		skull,
		"global_position",
		skull.global_position,
		dog_end_position.global_position,
		1
	)
	tween.connect("tween_completed", self, "end_encounter", [tween])
	tween.start()

func end_encounter(_a, _b, _old_tween):
	stats.world_state["BEAT_SKELETON"] = true
	Transition.go_to("res://Levels/0.0 Cave/SkelebonesHouse.tscn", "beat_game")

func action_noop(action):
	var text = "You " + action + "...\n"
	battle_menu.show_text(text)
	var dialogue = null
	match action.to_lower():
		"smell":
			dialogue = {
					"begin" : [
						"TEXT", "Smells like dusty old bones!!!",
						SKELETON_SPEECH_RATE, null, null, null
					],
				}
		"steal bone":
			if nostalgia_points >= MAX_NOSTALGIA:
				grab_skull()
				return
			else:
				dialogue = {
						"begin" : [
							"TEXT", "You try to steal a bone, but the skeleton is too focused!",
							SKELETON_SPEECH_RATE, "next", null, null
						],
						"next" : [
							"TEXT", "Maybe if the skeleton was more distracted...",
							SKELETON_SPEECH_RATE, null, null, null
						],
					}
		"play dead":
			dialogue = get_play_dead_dialogue()
		"roll over":
			dialogue = {
					"begin" : [
						"TEXT", "HEHEHEH... DO YOU WANT A BELLY RUB?",
						SKELETON_SPEECH_RATE, end_if_seen_before("increment", "belly_rub"), null, null, SKELETON_VOICE_PITCH
					],
					"increment" : [
						"TEXT", "DISTRACTION +1",
						SKELETON_SPEECH_RATE, null, [self, "increment_nostalgia_points"], null, SKELETON_VOICE_PITCH
					]
				}
	battle_menu.call_deferred("show_dialogue", dialogue)

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
			"TEXT", "HEHEHEH! LET ME HAVE THAT!",
			SKELETON_SPEECH_RATE, "FETCH", null, null, SKELETON_VOICE_PITCH
		],
		"FETCH" : [
			"TEXT", "GO FETCH, PUPPY!",
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
			dialogue = {
				"begin" : [
					"TEXT", "HEHEH- WHAT A SHABBY OLD BONE! WONDER WHICH SAP LOST THAT?",
					SKELETON_SPEECH_RATE, "nostalgia_points", null, null, SKELETON_VOICE_PITCH
				],
				"nostalgia_points" : [
					"TEXT", "HEHEHEHEHEH",
					SKELETON_SPEECH_RATE, end_if_seen_before("increment", "bone"), null, null, SKELETON_VOICE_PITCH
				],
				"increment" : [
					"TEXT", "DISTRACTION +1",
					SKELETON_SPEECH_RATE, null, [self, "increment_nostalgia_points"], null, SKELETON_VOICE_PITCH
				]
			}
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
					"TEXT", "HEY! THAT'S MY KEY!",
					SKELETON_SPEECH_RATE, "nostalgia_points", null, null, SKELETON_VOICE_PITCH
				],
				"nostalgia_points" : [
					"TEXT", "ISN'T IT COOL???? IT'S GOT MY FACE ON IT!",
					SKELETON_SPEECH_RATE, end_if_seen_before("increment", "key"), null, null, SKELETON_VOICE_PITCH
				],
				"increment" : [
					"TEXT", "DISTRACTION +1",
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
		 "steal bone", "smell", "play dead", "roll over"
	]
}

func _ready():
	Jukebox.play_song("res://tunes/cave/salamanders.wav")
	battle_menu.init(battle_impl)
