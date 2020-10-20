extends Node2D

onready var phase1_detection = $BarkSalamanderEvent

onready var EffectHelper = preload("res://effects/EffectHelper.gd")
onready var barksalamander_cutscene = preload("res://Levels/0.0 Cave/BarkSalamanderEventPhase2.tscn")
onready var spawn_point = $Spawn

onready var stats = PlayerStats

export(NodePath) var player_path = null
export(NodePath) var wall_path = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if stats.inventory_get("skeleton_key") > 1:
		phase1_detection.queue_free()
		_on_BarkSalamanderEvent_cutscene_starting()

func _on_BarkSalamanderEvent_cutscene_starting():
	print("cutscene started!!")
	var player = get_node(player_path)
	player.set_blend_positions(Vector2.DOWN * 0)
	player.cutscene_input = Vector2.ZERO
	player.cutscene_mode = true
	EffectHelper.call_deferred(
		"place_effect", 
		self, barksalamander_cutscene,
		spawn_point.global_position,
		[self, "cutscene_done"])
		
func cutscene_done():
	var player = get_node(player_path)
	player.cutscene_mode = false
	if stats.check_bool("PSYCHIC_WALL_GONE"):
		get_node(wall_path).queue_free()
