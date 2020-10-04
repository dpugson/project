extends Node

onready var Player = preload("res://player/player.tscn")

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal out_of_health
signal health_changed(value)
signal max_health_changed(value)

var inventory : Dictionary = {}
var world_state : Dictionary = {}
var curr_scene = null
var player_position = null # [x,y]

var spawn_metadata = null

func player_position_save(position: Vector2):
	if position == null:
		player_position = null
		return
	else:
		player_position = [position.x, position.y]
		
func player_position_get() -> Vector2:
	var p = Vector2.ZERO
	p.x = player_position[0]
	p.y = player_position[1]
	return p

func spawn_player(player, player_parent, camera_path, position, orientation):
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

func inventory_add(item_name):
	var count = inventory.get(item_name, 0)
	inventory[item_name] = count + 1
	
func inventory_get(item_name: String) -> int:
	return inventory.get(item_name, 0)
	
func check_bool(stat_name: String) -> bool:
	return world_state.get(stat_name, false)

func load_player_data():
	pass

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
	load_player_data()

