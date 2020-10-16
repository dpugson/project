extends Node2D

onready var person = $Person
onready var animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer
onready var timer = $Timer

export var splash = false
export(int) var talk_radius = null
export var watch_player = false
export(float) var appear_delay = 2

const VOICE_PITCH = 1.5

signal appeared

const angry = "res://sprites/cavestuff/salamanders/green_react0.png"
const shifty = "res://sprites/cavestuff/salamanders/green_react1.png"


var dialogue = {
	"begin" : ["TEXT", "See- it's LOVE! What did I tell ya?", 0.02, null, null, null, 1.5]
}

func _ready():
	person.watchPlayer = watch_player
	if talk_radius != null:
		person.seenCollisionShape.scale.x = talk_radius
		person.seenCollisionShape.scale.y = talk_radius
	person.init(animated_sprite)
	person.set_dialogue(dialogue)
	if splash:
		animation_player.play("before_appear")
		if appear_delay > 0:
			timer.wait_time = appear_delay
			timer.connect("timeout", self, "play_splash_appear")
			timer.start()
			person.seenCollisionShape.disabled = true
		else:
			animation_player.play("appear")
	else:
		animation_player.play("default")
	
func play_splash_appear():
	person.seenCollisionShape.disabled = false
	animation_player.play("appear")
	
func appeared():
	emit_signal("appeared")
	
func set_dialogue(new_dialogue):
	person.set_dialogue(new_dialogue)
	

