extends Node2D

onready var audioplayer = $flute
onready var doggo = $doggo
onready var animation = $AnimationPlayer

onready var korokoro = load("res://tunes/instrument_sounds/flute_korokoro.wav")
onready var u = load("res://tunes/instrument_sounds/flute_u.wav")

var current_sound = "NONE"
var new_sound = "NONE"
var sounds_stack = []

#onready var sounds_dict = {
#	"music_left" : [u, .75, "meri"], #tsu meri
#	#"music_left" : [u, .82, "meri"], #tsu kari
#	#"music_left" : [korokoro, .82, "meri"],
#	"music_up": [u, .94, "jammin"],
#	"music_down": [u, 1, "jammin"],
#	"music_right": [u, 1.25, "meri"],
#	"bark": [u, 1.4, "jammin"],
#	"look": [u, 1.45, "jammin"],
#	"sing_low": [korokoro, .6, "jammin"],
#	"sing_mid": [korokoro, .9, "meri"],
#	"sing_high": [korokoro, 1.0, "jammin"],
#}

#onready var sounds_dict = {
#	#"music_left" : [u, .75, "meri"], #tsu meri
#	#"music_left" : [u, .82, "meri"], #tsu kari
#	"music_left" :  [u, .94, "jammin"],
#	"music_up": [u, 1, "jammin"],
#	"music_down": [u, 1.25, "meri"],
#	"music_right": [u, 1.4, "jammin"],
#	"bark": [u, 1.45, "jammin"],
#	"look": [korokoro, 1, "meri"],
#}

onready var sounds_dict = {
	#"music_left" : [u, .75, "meri"], #tsu meri
	#"music_left" : [u, .82, "meri"], #tsu kari
	"music_left" :  [u, 1, "meri"],
	"music_up": [u, 1.26, "jammin"],
	"music_down": [u, 1.32, "meri"],
	"music_right": [u, 1.5, "jammin"],
	"bark": [u, 1.9, "meri"],
	"look": [u, 2, "jammin"],
	"sing_low": [korokoro, 1.8, "jammin"],
	"sing_mid": [korokoro, 1.9, "meri"],
	"sing_high": [korokoro, 2.0, "jammin"],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_with_pitch(note, pitch, animation_to_play):
	audioplayer.stream = note
	audioplayer.pitch_scale = pitch/2.0
	audioplayer.play()
	doggo.animation = animation_to_play
	doggo.frame = 0
	doggo.play()

func stop():
	audioplayer.stop()
	doggo.animation = "default"

func _process(_delta):
	if current_sound != new_sound:
		current_sound = new_sound
		if new_sound == "NONE":
			stop()
		else:
			play_with_pitch(
				sounds_dict[current_sound][0],
				sounds_dict[current_sound][1],
				sounds_dict[current_sound][2])

func _input(event):
	for key in sounds_dict:
		if event.is_action_pressed(key):
			audioplayer.volume_db = 0
			animation.stop()
			new_sound = key
			sounds_stack.append(new_sound)
			break
		if event.is_action_released(key):
			sounds_stack.erase(key)
			if len(sounds_stack) == 0:
				new_sound = "NONE"
			else:
				new_sound = sounds_stack.back()
			break

func _on_flute_finished():
	doggo.animation = "default"
