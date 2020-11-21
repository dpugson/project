extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var bathroomSP = $BathroomDoorSP
onready var labSP = $LabDoorSP
onready var breakRoomSP = $BreakRoomDoorSP
onready var animation = $AnimationPlayer
onready var camera = $PuppyCamera
onready var robot = $Robot

func _ready():
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
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
