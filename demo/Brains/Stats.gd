extends Node

onready var Player = preload("res://player/player.tscn")

export(int) var max_health = 10 setget set_max_health
var health = max_health setget set_health

signal out_of_health
signal health_changed(value)
signal max_health_changed(value)

var inventory : Dictionary = {}
var world_state : Dictionary = {}
var save_spot_name = null
var save_spot_tscn = null
var G = 0

var menu_allowed = true

var spawn_metadata = null

var loaded = false

signal save_complete

const SAVE_FILE_LOCATION = "user://savegame.save"

func save_game(new_save_spot_name, tscn):
	print("SAVING")
	var file = File.new()
	file.open(SAVE_FILE_LOCATION, File.WRITE)
	file.store_line(JSON.print({
		"inventory" : inventory,
		"world_state" : world_state,
		"save_spot_name" : new_save_spot_name,
		"save_spot_tscn" : tscn,
		"G" : G,
		"max_health" : max_health,
		"health" : health
	}, " "))
	file.close()
	emit_signal("save_complete")
	
func load_game():
	if not loaded:
		loaded = true
		var file = File.new()
		if not file.file_exists(SAVE_FILE_LOCATION):
			return # No save file!
		file.open(SAVE_FILE_LOCATION, File.READ)
		var json = parse_json(file.get_as_text())
		print("CURRENT STATE: ", json)
		inventory = json.get("inventory", {})
		world_state = json.get("world_state", {})
		save_spot_name = json.get("save_spot_name", null)
		save_spot_tscn = json.get("save_spot_tscn", null)
		max_health = json.get("max_health", 10)
		health = json.get("health", 10)
		G = json.get("G", 0)
		file.close()

func spawn_player(player, player_parent, camera_path, position: Vector2, orientation: Vector2):
	if (player == null):
		player = Player.instance()
		player_parent.add_child(player)
	player.position = position
	if camera_path != null:
		var transform = RemoteTransform2D.new()
		transform.remote_path = camera_path
		player.add_child(transform)
	if orientation != null:
		player.set_blend_positions(orientation)
		player.turbo_input = orientation
		player.previous_input = orientation

func inventory_add(item_name):
	var count = inventory.get(item_name, 0)
	inventory[item_name] = count + 1
	
func inventory_get(item_name: String) -> int:
	return inventory.get(item_name, 0)
	
func check_bool(stat_name: String) -> bool:
	return world_state.get(stat_name, false)

func set_max_health(value):
	max_health = value
	self.health = clamp(health, 0, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("out_of_health")

func _ready():
	self.health = max_health
	load_game()

