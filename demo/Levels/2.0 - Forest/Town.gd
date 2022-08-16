extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")


onready var theaterSP = $Doors/TheaterSP
onready var prisonSP = $Doors/PrisonSP
onready var bottomSP = $BottomSP

func _ready():
	var player_position = player.position
	var orientation = Vector2.DOWN
	var spawn_player = true
	Jukebox.play_song("res://tunes/forest/starswaltz_slow.wav")
	match stats.spawn_metadata:
		"theater":
			player_position = theaterSP.position
			orientation = Vector2.RIGHT
		"prison":
			player_position = prisonSP.position
			orientation = Vector2.LEFT
		_:
			player_position = bottomSP.position
			orientation = Vector2.UP
	if spawn_player:
		stats.spawn_player(
			player, null, 
			"../../../PuppyCamera", player_position, orientation)


func _on_BottomTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Tangle.tscn", "top")

func _on_TheaterDoor_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/Stage.tscn", "door")

func _on_BakeryDoor_transition_triggered():
	pass # Replace with function body.

func _on_PrisonDoor_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/town/jail/jail.tscn", "door")

func _on_HomeDoor_transition_triggered():
	pass # Replace with function body.
