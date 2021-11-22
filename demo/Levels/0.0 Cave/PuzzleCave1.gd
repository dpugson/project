extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var gilby = $YSort/Gilby
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

const already_been_in_here = "ALREADY_BEEN_IN_PZC1"

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
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
	if not stats.check_bool(already_been_in_here):
		gilby.connect("appeared", self, "opine")
	gilby.set_dialogue(get_normal_dialogue(gilby.VOICE_PITCH))
		

func get_normal_dialogue(pitch):
	return {
		"begin" : [
			"TEXT", "Don't worry about it! They're just puzzles!", 0.03,
			null, null, null, pitch
		]
	}

func get_dialogue(gilby_voice):
	return {
		"begin" : [
			"TEXT", "Oh, hey! Just a quick\nwarning about this guy...",
			0.02, "warning", null, gilby.shifty, gilby_voice
		],
		"warning" : [
			"TEXT", "He was a bit of an...",
			0.02, "warning2", null, null, gilby_voice
		],
		"warning2" : [
			"TEXT", "Umm...",
			0.02, "warning3", null, null, gilby_voice
		],
		"warning3" : [
			"TEXT", "Oddball!",
			0.02, "warning4", null, gilby.angry, gilby_voice
		],
		"warning4" : [
			"TEXT", "He was into these RPG video games.",
			0.02, "warning5", null, gilby.shifty, gilby_voice
		],
		"warning5" : [
			"TEXT", "He liked to make these annoying puzzles and stuff.",
			0.02, "warning6", null, null, gilby_voice
		],
		"warning6" : [
			"TEXT", "But hey! Don't worry about it! I'll tag along\nand help you out.",
			0.02, null, null, null, gilby_voice
		],
	}

func opine():
	stats.world_state[already_been_in_here] = true
	DialogueHelper.showDialogue(self, get_dialogue(gilby.VOICE_PITCH))

func _on_UpperTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave2.tscn", "bottom")

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/Cave03.tscn", "crumbly")
