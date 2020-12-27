extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player

onready var startSP = $StartSP
onready var helmSP = $HelmSP
onready var engineSP = $EngineSP
onready var treeSP = $TreeSP
onready var pantrySP = $PantrySP

func _ready():
	Jukebox.play_song("res://tunes/crimbus/crimmas.wav")
	var player_position = startSP.position
	var orientation = Vector2.UP
	
	match stats.spawn_metadata:
		"helm":
			player_position = helmSP.position
			orientation = Vector2.DOWN
		"engine":
			player_position = engineSP.position
			orientation = Vector2.DOWN
		"tree":
			player_position = treeSP.position
			orientation = Vector2.DOWN
		"pantry":
			player_position = pantrySP.position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func _on_HelmTZ_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/Helm.tscn", "bottom")

func _on_PantryTZ_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/CookieRoom.tscn", "bottom")

func _on_EngineTZ_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/EngineRoom.tscn", "bottom")

func _on_TreeTZ_transition_triggered():
	Transition.go_to("res://Levels/22.0 Crimbus/TreeRoom.tscn", "bottom")
