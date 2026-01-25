extends Node2D

onready var audioplayer = $AudioStreamPlayer
onready var voice = $voice
onready var leftPaw = $Body/LeftPaw
onready var rightPaw = $Body/RightPaw
onready var body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_with_pitch(pitch):
	audioplayer.pitch_scale = pitch
	audioplayer.play()
	rightPaw.frame = 0
	rightPaw.play()
	if pitch > 1.4:
		leftPaw.animation = "low"
	else:
		leftPaw.animation = "high"
	
func sing_with_pitch(pitch):
	body.animation = "singing"
	body.frame = 0
	body.play()
	voice.pitch_scale = pitch
	voice.play()

func _input(event):
	if event.is_action_pressed("music_left"):
		play_with_pitch(1)
	elif event.is_action_pressed("music_up"):
		play_with_pitch(1.26)
	elif event.is_action_pressed("music_down"):
		play_with_pitch(1.32)
		#play_with_pitch(1.9)
	elif event.is_action_pressed("music_right"):
		play_with_pitch(1.5)
		#play_with_pitch(2)
	#elif event.is_action_pressed("bark"):
	#	play_with_pitch(1.9)
	#elif event.is_action_pressed("look"):
	#	play_with_pitch(2)
	
	if event.is_action_pressed("sing_low"):
		sing_with_pitch(0.75)
	elif event.is_action_pressed("sing_mid"):
		sing_with_pitch(0.9)
	elif event.is_action_pressed("sing_high"):
		sing_with_pitch(1.19)
	elif event.is_action_pressed("sing_highhigh"):
		sing_with_pitch(1.32)


func _on_voice_finished():
	body.animation = "default"
