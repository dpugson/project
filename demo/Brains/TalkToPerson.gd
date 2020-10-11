extends Node2D

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var playerDetectionZone = $PlayerDetectionZone

export(bool) var watchPlayer = false

var animated_sprite: AnimatedSprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_direction(d):
	animated_sprite.animation = d
	
func init(animated_sprite_input: AnimatedSprite):
	animated_sprite = animated_sprite_input
	animated_sprite.animation = "left"
	for direction in ["up", "down", "right", "left"]:
		var animation = animation_player.get_animation(direction)
		var track_index = animation.add_track(Animation.TYPE_METHOD)
		animation.track_set_path(track_index, "../Person")
		animation.track_insert_key(track_index, 0, {"method" : "set_direction" , "args" : [direction]})
	animation_tree.active = true
	
func set_dialogue(new_dialogue):
	self.dialogue = new_dialogue
	
var dialogue = {
	"begin" : [
		"TEXT", "Howdy!", 0.03, null
	]
}

func _physics_process(_delta):
	if(watchPlayer):
		if playerDetectionZone.can_see_player():
			var direction = (playerDetectionZone.player.global_position - global_position).normalized()
			animation_tree.set("parameters/idle/blend_position", direction)


func _on_SeenBox_seen(_obj):
	var direction = (playerDetectionZone.player.global_position - global_position).normalized()
	animation_tree.set("parameters/idle/blend_position", direction)
	DialogueHelper.call_deferred("showDialogue", self, dialogue)
