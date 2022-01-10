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
var main_volume = .75
var effects_volume = .75
var music_volume = .75

var menu_allowed = true

var spawn_metadata = null

var loaded = false

signal save_complete

const SAVE_FILE_LOCATION = "user://savegame.save"
const PREFERENCES_FILE_LOCATION = "user://preferences.save"

func _input(event):
	if event.is_action_pressed("smell"):
		start_smell_mode()
	if event.is_action_released("smell"):
		end_smell_mode()

signal put_on_hat
func put_on_hat(item_image):
	if world_state.get("HAT", null) == item_image and item_image != null:
		world_state["HAT"] = null
	else:
		world_state["HAT"] = item_image
	emit_signal("put_on_hat")

func update_volumes():
	for volume_pair in [
		["Master", main_volume],
		["Effects", effects_volume],
		["Music", music_volume]
	]:
		var buffer_name = volume_pair[0]
		var value = volume_pair[1]
		var index = AudioServer.get_bus_index(buffer_name)
		if value == 0:
			AudioServer.set_bus_mute(index, true)
		else:
			# translate "percent" into decibels
			var AUDIO_MAX = 0
			var AUDIO_MIN = -50 
			var massaged_value = value
			var decibels = AUDIO_MIN + (massaged_value * abs(AUDIO_MAX - AUDIO_MIN))
			print("setting ", buffer_name, " to ", decibels)
			AudioServer.set_bus_mute(index, false)
			AudioServer.set_bus_volume_db(index, decibels)
	save_preferences()

func save_game(new_save_spot_name, tscn):
	save_spot_name = new_save_spot_name
	save_spot_tscn = tscn
	print("SAVING GAME")
	var file = File.new()
	file.open(SAVE_FILE_LOCATION, File.WRITE)
	file.store_line(JSON.print({
		"inventory" : inventory,
		"world_state" : world_state,
		"save_spot_name" : new_save_spot_name,
		"save_spot_tscn" : tscn,
		"G" : G,
		"max_health" : max_health,
		"health" : health,
	}, " "))
	file.close()
	emit_signal("save_complete")
	
func load_game(force_load=false):
	if (not loaded) or force_load:
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
		load_preferences()

func load_preferences():
	var file = File.new()
	if not file.file_exists(PREFERENCES_FILE_LOCATION):
		return # No save file!
	file.open(PREFERENCES_FILE_LOCATION, File.READ)
	var json = parse_json(file.get_as_text())
	print("CURRENT PREFERENCES: ", json)
	main_volume = json.get("main_volume", .75)
	effects_volume = json.get("effects_volume", .75)
	music_volume = json.get("music_volume", .75)
	file.close()
	update_volumes()

func save_preferences():
	print("SAVING PREFERENCES")
	var file = File.new()
	file.open(PREFERENCES_FILE_LOCATION, File.WRITE)
	file.store_line(JSON.print({
		"main_volume" : main_volume,
		"effects_volume" : effects_volume,
		"music_volume" : music_volume
	}, " "))
	file.close()

func spawn_player_lite(player, position, orientation):
	player.position = position
	player.set_blend_positions(orientation)
	player.turbo_input = orientation
	player.previous_input = orientation

func spawn_player(player, player_parent, camera_path,
				position: Vector2, orientation: Vector2,
				camera_offset = null):
	if (player == null):
		player = Player.instance()
		player_parent.add_child(player)
	player.position = position
	if camera_path != null:
		var transform = RemoteTransform2D.new()
		transform.remote_path = camera_path
		player.add_child(transform)
		player.remote_transform = transform
		if camera_offset != null:
			transform.position.y += camera_offset
	if orientation != null:
		player.set_blend_positions(orientation)
		player.turbo_input = orientation
		player.previous_input = orientation

func inventory_add(item_name):
	var count = inventory.get(item_name, 0)
	inventory[item_name] = count + 1
	
func inventory_get(item_name: String) -> int:
	return inventory.get(item_name, 0)

func inventory_remove(item_name):
	var count = inventory.get(item_name, 1) - 1
	if (count <= 0):
		var _discard = inventory.erase(item_name)
	else:
		inventory[item_name] = count
	var item_data = ItemRegistry.get(item_name)
	if world_state.get("HAT", null) == item_data["image"]:
		world_state["HAT"] = null
		put_on_hat(null)

func set_bool(stat_name: String, value: bool = true):
	world_state[stat_name] = value
	
func check_bool(stat_name: String) -> bool:
	return world_state.get(stat_name, false)

# Return the value or null
func get(stat_name):
	return world_state.get(stat_name, null)

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

signal smell_mode_started
signal smell_mode_ended
func start_smell_mode():
	emit_signal("smell_mode_started")
func end_smell_mode():
	emit_signal("smell_mode_ended")

