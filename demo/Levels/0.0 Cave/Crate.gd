extends KinematicBody2D

var speed = Vector2.ZERO 
var destroyed_stat_name = ""
export var CUBE_SPEED = 100
export var friction = 6000
export var unique_name : String = ""
export var is_special_talky_cube = false

const DestructionEffect = preload("res://effects/signexplode.tscn")
const EffectHelper = preload("res://effects/EffectHelper.gd")
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var Player = preload("res://player/player.gd")
var Gilby = preload("res://Characters/salamanders/Gilby.gd")
onready var seen_box = $SeenBox

export(String, MULTILINE) var text = ""
signal destroyed
signal special_box_seen

func _physics_process(delta):
	var collision = move_and_collide(speed)
	if collision != null:
		if collision.collider is Player:
			speed = collision.normal * CUBE_SPEED * delta
	else:
		speed = speed.move_toward(Vector2.ZERO, friction)

func _ready():
	destroyed_stat_name = unique_name + "_BOX_DESTROYED"
	if unique_name != "":
		if PlayerStats.check_bool(destroyed_stat_name):
			print("hmmm")
			queue_free()
	if !is_special_talky_cube:
		seen_box.visible = false

func explode():
	if destroyed_stat_name != "":
		PlayerStats.world_state[destroyed_stat_name] = true
	queue_free()
	EffectHelper.place_effect_global(self, DestructionEffect)
	emit_signal("destroyed")

func _on_SeenBox_seen(_obj):
	if is_special_talky_cube:
		emit_signal("special_box_seen")
	elif text != "":
		var dialogue = {
		"begin" : ["TEXT", text, 0.03, null]
		}
		DialogueHelper.showDialogue(self, dialogue)
		return
		
func get_slammed(_power):
	explode()

