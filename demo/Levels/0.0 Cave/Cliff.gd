extends Node2D

onready var player = $player
onready var transition = Transition

# Called when the node enters the scene tree for the first time.
func _ready():
	Jukebox.play_song("res://tunes/cave/cliff.wav")
	player.set_blend_positions(Vector2.RIGHT)

func _on_TransitionZone_transition_triggered():
	transition.go_to("res://Levels/0.0 Cave/Cave03.tscn", "crumbly")
