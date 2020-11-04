extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var pillowSP = $PillowSpawnPoint
onready var doorSP = $DoorSpawnPoint
onready var animation = $AnimationPlayer
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"pillow":
			player_position = pillowSP.position
			orientation = Vector2.DOWN
			animation.play("fall")
		"door":
			player_position = doorSP.position
			orientation = Vector2.LEFT
		_:
			player_position = doorSP.position
			orientation = Vector2.LEFT
	stats.spawn_player(
		player, null, null, player_position, orientation)



func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/PuzzleCave2.tscn", "secret")


func _on_Letter_seen(_obj):
	var letter_dialogue = {
		"begin" : [
			"TEXT", "It's a dusty old note written in neat cursive.",
			0.03, "note"
		],
		"note" : [
			"TEXT", "WRONG GUESS! HEHEHEHEH\nMY HIGHEST REGARDS- YOUR DUNGEON MASTER <3",
			0.03, null
		]
	}
	DialogueHelper.showDialogue(self, letter_dialogue)

const GOT_PILLOW_G = "got_basement_pillow_g"

func _on_Pillows_seen(_obj):
	var pillow_dialogue = {
		"begin" : [
			"TEXT", "Nice and soft and dusty.",
			0.03, null
		]
	}
	if not stats.check_bool(GOT_PILLOW_G):
		stats.world_state[GOT_PILLOW_G] = true
		pillow_dialogue["findg"] = [
			"TEXT", "You find 10 G in the pillows!",
			0.03, null
		]
		pillow_dialogue["begin"][3] = "findg"
		stats.G += 10
	DialogueHelper.showDialogue(self, pillow_dialogue)
