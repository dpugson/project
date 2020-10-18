extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var secretSpawnPoint = $SecretSpawnPoint
onready var gilby = $YSort/Gilby
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var hole = $Hole
onready var holeTween = $Hole/Tween
onready var Lever = preload("res://Levels/0.0 Cave/Lever.gd")
onready var timer = $Timer

const already_been_in_here = "ALREADY_BEEN_IN_PZC2"
const pulled_left = "Ya pulled the left"
const pulled_right = "Ya pulled the right"
const pulled_left_first_apologized = "pulled_left_first_apologized"
const pulled_right_first_reprimanded = "pulled_left_first_apologized"
const pulled_both_explained_dash = "explained_dash"
const you_did_it = "you_defeated_the_levers"

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"secret":
			player_position = secretSpawnPoint.position
			orientation = Vector2.RIGHT
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
	gilby.set_dialogue(get_normal_dialogue(gilby.VOICE_PITCH))
	if not stats.check_bool(pulled_both_explained_dash):
		gilby.connect("appeared", self, "opine")
	
func get_normal_dialogue(pitch):
	var left = stats.check_bool(pulled_left)
	var right = stats.check_bool(pulled_right)
	
	if !left and !right:
		return {
			"begin" : [
				"TEXT", "Pull the LEFT! I'm sure of it!", 0.03,
				null, null, null, pitch
			]
		}
	elif left and !right:
		return {
			"begin" : [
				"TEXT", "Yeah, yeah... The RIGHT switch!\nIt's the... Right... Switch!!!!", 0.03,
				null, null, null, pitch
			],
		}
	elif !left and right:
		return {
			"begin" : [
				"TEXT", "L-E-F-T!", 0.03,
				null, null, null, pitch
			]
		}
	elif left and right:
		if !stats.check_bool(you_did_it):
			return {
				"begin" : [
					"TEXT", '"J" stands for JUST DO IT!!!', 0.03,
					null, null, null, pitch
				]
			}
		else:
			return {
				"begin" : [
					"TEXT", "You did it!!! You're a natural!", 0.03,
					null, null, null, pitch
				]
			}

func get_initial_dialogue(gilby_voice):
	return {
		"begin" : [
			"TEXT", "Oh! This one! I remember this one!",
			0.02, "warning", null, gilby.angry, gilby_voice
		],
		"warning" : [
			"TEXT", "You gotta pull one of the levers!",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "Umm... You wanna know which lever?",
			0.02, "warning3", null, gilby.shifty, gilby_voice
		],
		"warning3" : [
			"TEXT", "Uhh... The left! I'm pretty sure it was the left.",
			0.02, "warning4", null, gilby.shifty, gilby_voice
		],
		"warning4" : [
			"TEXT", "Yeah, now that I think about it, it is definitely the left!",
			0.02, null, null, gilby.angry, gilby_voice
		],
	}
	
func get_left_first_dialogue(gilby_voice):
	return {
		"begin" : [
			"TEXT", "Ohhhhh geeze!!!!",
			0.02, "warning", null, gilby.angry, gilby_voice
		],
		"warning" : [
			"TEXT", "I'M SO SORRY!!!!",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "What was I thinking????",
			0.02, "warning3", null, gilby.shifty, gilby_voice
		],
		"warning3" : [
			"TEXT", "I could've sworn it was the left...",
			0.02, "warning4", null, gilby.shifty, gilby_voice
		],
		"warning4" : [
			"TEXT", "But yeah, it must be the right... The right, yeah!!!",
			0.02, null, null, gilby.angry, gilby_voice
		],
	}
	
func get_right_first_dialogue(gilby_voice):
	return {
		"begin" : [
			"TEXT", "What!! Were you even listening??",
			0.02, "warning", null, gilby.angry, gilby_voice
		],
		"warning" : [
			"TEXT", "You gotta pull the lever on the LEFT!",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "The LEFT LEVER!",
			0.02, "warning3", null, gilby.shifty, gilby_voice
		],
		"warning3" : [
			"TEXT", "LEFT LEFT LEFT.",
			0.02, null, null, gilby.angry, gilby_voice
		],
	}
	
func explain_pegasus_dash(gilby_voice):
	return {
		"begin" : [
			"TEXT", "OHH!!! I just remembered!!",
			0.02, "warning", null, gilby.angry, gilby_voice
		],
		"warning" : [
			"TEXT", "BOTH of the levers dump you in a hole!",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "To get through, you just gotta bash through\nthe door using a Turbo Dash!",
			0.02, "warning3", null, gilby.shifty, gilby_voice
		],
		"warning3" : [
			"TEXT", "You do know how to turbo dash, right???",
			0.02, "warning4", null, gilby.shifty, gilby_voice
		],
		"warning4" : [
			"TEXT", "Wah- no?? Well then, I'll have to teach you!",
			0.02, "warning5", null, gilby.angry, gilby_voice
		],
		"warning5" : [
			"TEXT", "Picture the essence of SPEED in your THOUGHT PALACE.",
			0.02, "warning6", null, gilby.angry, gilby_voice
		],
		"warning6" : [
			"TEXT", "THE WIND AT YOUR BACK!!! THE INCREDIBLE ROARING WIND!!!",
			0.02, "warning7", null, gilby.angry, gilby_voice
		],
		"warning7" : [
			"TEXT", "VISUALIZE!!!",
			0.02, "warning8", null, gilby.angry, gilby_voice
		],
		"warning8" : [
			"TEXT", 'And then press "J" with all your might!!!',
			0.02, null, [self, "teach_turbo_dash"], gilby.angry, gilby_voice
		],
	}
	
func congratulate(gilby_voice):
	return {
		"begin" : [
			"TEXT", "YEAHH!!!!!",
			0.02, "warning", null, gilby.angry, gilby_voice
		],
		"warning" : [
			"TEXT", "You totally DESTROYED that DOOR!!!!",
			0.02, null, null, null, gilby_voice
		],
	}
	
func teach_turbo_dash():
	stats.world_state["turbodash"] = true

func opine():
	var left = stats.check_bool(pulled_left)
	var right = stats.check_bool(pulled_right)
	if not stats.check_bool(already_been_in_here):
		stats.world_state[already_been_in_here] = true
		DialogueHelper.showDialogue(self, get_initial_dialogue(gilby.VOICE_PITCH))
		return
	elif left and !right and not stats.check_bool(pulled_left_first_apologized):
		stats.world_state[pulled_left_first_apologized] = true
		DialogueHelper.showDialogue(self, get_left_first_dialogue(gilby.VOICE_PITCH))
		return
	elif !left and right and not stats.check_bool(pulled_right_first_reprimanded):
		stats.world_state[pulled_right_first_reprimanded] = true
		DialogueHelper.showDialogue(self, get_right_first_dialogue(gilby.VOICE_PITCH))
		return
	elif left and right:
		stats.world_state[pulled_both_explained_dash] = true
		DialogueHelper.showDialogue(self, explain_pegasus_dash(gilby.VOICE_PITCH))
		return

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave1.tscn", "top")


func _on_BasementTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/Basement.tscn", "door")

func _on_Lever_pulled(side):
	match side:
		"left":
			stats.world_state[pulled_left] = true
		"right":
			stats.world_state[pulled_right] = true
	hole.visible = true
	player.cutscene_mode = true
	player.cutscene_input = Vector2.ZERO
	
	timer.connect("timeout", self, "fall")
	timer.wait_time = 1
	timer.start()

func fall():
	holeTween.interpolate_property(
		player,
		"position",
		player.position,
		hole.position,
		0.1
	)
	holeTween.connect("tween_completed", self, "real_fall")
	holeTween.start()
	
func real_fall(_a, _b):
	Transition.go_to("res://Levels/0.0 Cave/Basement.tscn", "pillow")

func _on_LeftLever_pulled(_side):
	_on_Lever_pulled("left")

func _on_RightLever_pulled(_side):
	_on_Lever_pulled("right")

func _on_Door_destroyed():
	stats.world_state[you_did_it] = true
	gilby.set_dialogue(congratulate(gilby.VOICE_PITCH))

func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave3.tscn", "bottom")
