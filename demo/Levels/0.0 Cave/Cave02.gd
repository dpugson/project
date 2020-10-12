extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var topSpawnPoint = $TopSpawnPoint
onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition

const angry_message = "WHO KEEPS DESTROYING ALL MY SIGNS??"

# Called when the node enters the scene tree for the first time.
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
			orientation = Vector2.DOWN
		_:
			player_position = bottomSpawnPoint.position
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
#
#
#var stalag_dialogue = {
#	"begin" : [
#		"TEXT", "It's a stalagmite!", 0.02, 
#		[
#			["Do not lick", "dont"],
#			["Lick", "lick"]
#		]
#	],
#	"lick" : [
#		"ACTION", "It tastes.... Salty.", 0.02,
#		[
#			["...", "getsalt"]
#		],
#		[self, "resolve_getsalt"]
#	],
#	"getsalt" : "TBD",
#	"dont" : [
#		"TEXT", "Better not to lick than to become sick.", 0.01, null
#	]
#}
#
#const GOT_MEMORY_OF_SALT = "got_memory_of_salt"
#
#func resolve_getsalt():
#	if stats.check_bool(GOT_MEMORY_OF_SALT):
#		stalag_dialogue["getsalt"] = [
#			"TEXT", "You remember salty.", 0.02, null
#		]
#	else:
#		stalag_dialogue["getsalt"] = [
#			"ACTION", "YOU ACQUIRE ONE MEMORY OF SALT.", 0.02, null,
#			[self, "getsaltmemory"]
#		]
#
#func getsaltmemory():
#	stats.world_state[GOT_MEMORY_OF_SALT] = true
#	stats.inventory_add('memoryofsalt')
#
#func _on_StalagSeenBox_seen(_obj):
#	if !stats.check_bool(GOT_MEMORY_OF_SALT):
#		DialogueHelper.showDialogue(self, stalag_dialogue)

func _on_BottomDoor_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave01.tscn", "door")

func _on_TopDoor_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave03.tscn", "upper")
