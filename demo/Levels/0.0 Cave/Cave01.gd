extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var scratches = $Scratches
onready var transition = Transition
onready var spawnPoint = $SpawnPoint
onready var stats = PlayerStats
onready var player = $player
onready var animation = $AnimationPlayer
onready var tween = $Tween
onready var timer = $Timer
onready var door = $Door
onready var doorSpawnPoint = $DoorSpawnPoint

var in_cutscene = false

func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var player_orientation = Vector2.UP
	if stats.spawn_metadata == "door":
		player_position = doorSpawnPoint.position
		player_orientation = Vector2.DOWN
	elif stats.player_position != null:
		player_position = stats.player_position_get()
		player_orientation = Vector2.DOWN
	else:
		player_position = spawnPoint.position
		player_orientation = Vector2.UP
	stats.spawn_player(player, self, null, player_position, player_orientation)
 
const scratches_dialogue = {
	"begin" : [
		"TEXT", "Someone likes to make scratches, huh?",
		0.02, null
	]
}

func _on_Scratches_seen(_obj):
	DialogueHelper.showDialogue(self, scratches_dialogue)

const leaves_dialogue = {
	"begin" : [
		"TEXT", "A nice big pile of crunchy leaves.",
		0.02, null
	]
}

func _on_LeafPile_seen(_obj):
	DialogueHelper.showDialogue(self, leaves_dialogue)

func walk_player_to_ball():
	if in_cutscene:
		return
	in_cutscene = true
	print("HI")
	player.set_process_input(false)
	player.cutscene_input = Vector2.ZERO
	player.cutscene_mode = true
	timer.connect("timeout", self, "play_tween")
	timer.start()

func play_tween():
	player.cutscene_input = Vector2.DOWN
	var anim_start_pos = Vector2.ZERO
	anim_start_pos.x = 916.386
	anim_start_pos.y = 560.484
	tween.interpolate_property(
		player,
		"position",
		player.position,
		anim_start_pos,
		1
	)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	player.cutscene_input = Vector2.RIGHT
	animation.play("WalkToBall")
	
const cutscene_ball_dialogue = {
"begin" : ["TEXT", "BALL!!!!", 0.02, null]
}

func play_cutscene_ball_dialogue():
	DialogueHelper.showDialogue(self, cutscene_ball_dialogue)
	
func done_walking():
	player.animation_state.travel("idle")
	player.set_process_input(true)
	player.cutscene_mode = false
	self.set_deferred("in_cutscene", false)

func _on_Door_transition_triggered():
#	if !stats.check_bool("ball_took_ball"):
#		walk_player_to_ball()
#	else:
#		transition.go_to("res://Levels/0.0 Cave/Cave02.tscn", "bottom")
	transition.go_to("res://Levels/0.0 Cave/Cave02.tscn", "bottom")
