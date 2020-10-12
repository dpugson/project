extends Node2D

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var upperSpawnPoint = $UpperSpawnPoint
onready var crumblySpawnPoint = $CrumblySpawnPoint
onready var stats = PlayerStats
onready var player = $YSort/player
onready var transition = Transition

onready var barksalamander_detectionzone = $YSort/BarkSalamanderEvent
onready var EffectHelper = preload("res://effects/EffectHelper.gd")
onready var barksalamander_cutscene = preload("res://Levels/0.0 Cave/BarkSalamanderEventPhase2.tscn")
onready var wall = $WallOfPsychicEnergy
onready var tween = $Tween
onready var camera = $PuppyCamera
onready var cameraPositionAtEnd = $CameraAtEnd
onready var save_star = $YSort/SaveStar

# Called when the node enters the scene tree for the first time.
func _ready():
	Jukebox.play_song("res://tunes/cave/fallen.wav")
	var player_position = Vector2.ZERO
	var player_orientation = Vector2.DOWN
	match stats.spawn_metadata:
		"Caves - The Big Room":
			player_position = save_star.position
		"upper":
			player_position = upperSpawnPoint.position
		"crumbly":
			player_position = crumblySpawnPoint.position
		_:
			player_position = upperSpawnPoint.position
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, player_orientation)

	if stats.check_bool("GOT_SWIMMING_CERT"):
		barksalamander_detectionzone.queue_free()
		_on_BarkSalamanderEvent_cutscene_starting()
		cutscene_done()

func _on_UpperDoor_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave02.tscn", "top")

func _on_BarkSalamanderEvent_cutscene_starting():
	print("cutscene started!!")
	player.set_blend_positions(Vector2.DOWN * 0)
	player.cutscene_input = Vector2.ZERO
	player.cutscene_mode = true
	EffectHelper.call_deferred(
		"place_effect", 
		player, barksalamander_cutscene,
		barksalamander_detectionzone.global_position,
		[self, "cutscene_done"])
		
func cutscene_done():
	player.cutscene_mode = false
	wall.queue_free()
	
const HAS_ESCAPED_CAVE = "HAS_ESCAPED_CAVE"
func _on_WayOut_transition_triggered():
	if not stats.check_bool(HAS_ESCAPED_CAVE):
		stats.world_state[HAS_ESCAPED_CAVE] = true
		player.queue_free()
		tween.interpolate_property(
			camera,
			"position",
			camera.global_position,
			cameraPositionAtEnd.position,
			2
		)
		tween.connect("tween_all_completed", self, "play_riptide_dialogue")
		tween.start() 
		

const green_angry = "res://sprites/cavestuff/salamanders/green_react0.png"
const green_shifty = "res://sprites/cavestuff/salamanders/green_react1.png"
const pink_chuffed = "res://sprites/cavestuff/salamanders/pink_react0.png"
const pink_thinking = "res://sprites/cavestuff/salamanders/pict_react1.png"

var riptide_dialogue = {
	"begin" : [
		"TEXT", "Hmm....", 0.03,
		"tell", null, pink_chuffed
	],
	"tell" : [
		"TEXT", "We did tell him about the dangerous currents, right?", 0.02,
		"ummm", null, pink_thinking
	],
	"ummm" : [
		"TEXT", "Ummmm.....", 0.03,
		"crap", null, green_shifty, 1.5
	],
	"crap": [
		"TEXT", "Crap!!", 0.01,
		null, [self, "transition_to_riptide"], green_angry, 1
	],
}

func play_riptide_dialogue():
	DialogueHelper.showDialogue(self, riptide_dialogue, true)

func transition_to_riptide():
	transition.go_to("res://Levels/0.0 Cave/Riptide.tscn")

func _on_TransitionZone_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cliff.tscn")