extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var scratches = $Scratches
onready var transition = Transition
onready var spawnPoint = $SpawnPoint
onready var stats = PlayerStats

func _ready():
	var player_position = Vector2.ZERO
	if stats.player_position != null:
		player_position = stats.player_position_get()
	else:
		player_position = spawnPoint.position
	stats.spawn_player(self, null, player_position, Vector2.UP)
 
const scratches_dialogue = {
	"begin" : [
		"TEXT", "Someone likes to make scratches, huh?",
		0.02, null
	]
}

func _on_Scratches_seen():
	DialogueHelper.showDialogue(self, scratches_dialogue)

const leaves_dialogue = {
	"begin" : [
		"TEXT", "A nice big pile of crunchy leaves.",
		0.02, null
	]
}

func _on_LeafPile_seen():
	DialogueHelper.showDialogue(self, leaves_dialogue)


func _on_Door_transition_triggered():
	transition.go_to("res://Levels/1.0 - Lab/Laboratory.tscn")
