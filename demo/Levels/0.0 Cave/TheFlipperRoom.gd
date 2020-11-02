extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition
onready var bottomSpawnPoint = $BottomSpawnPoint
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var flippers = $flippers

const grabbed_flippers = "GRABBED_FLIPPERS"

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"bottom":
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
		_:
			player_position = bottomSpawnPoint.position
			orientation = Vector2.UP
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)
	if stats.check_bool(grabbed_flippers):
		remove_flippers()

func _on_FlippersSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "A lovely pair of yellow flippers. They smell clean.", 0.03,
			[["TAKE", "take"], ["LEAVE", "leave"]], null, null
		],
		"take" : [
			"TEXT", "You acquire some cool new FLIPPERS.", 0.03,
			null, [self, "take_flippers"], null
		],
		"leave" : [
			"TEXT", "Maybe you'll come back for them later.", 0.03,
			null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)

func take_flippers():
	stats.world_state[grabbed_flippers] = true
	stats.inventory_add("flippers")
	remove_flippers()

func remove_flippers():
	flippers.queue_free()

func _on_HoleSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "A deep, dark, cool hole. It calls to you.", 0.03,
			null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)

func _on_BaronSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "A lovely portrait. You think its eyes look a little sad.", 0.03,
			null, null, null, null
		]
	}
	DialogueHelper.showDialogue(self, dialogue)

func _on_LowerTZ_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/SkelebonesLivingRoom.tscn", "top")


func _on_TransitionZone_transition_triggered():
	Transition.go_to("res://Levels/0.0 Cave/Cave03.tscn", "falling")
