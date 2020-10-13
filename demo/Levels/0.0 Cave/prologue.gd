extends Node2D
 
onready var animation = $AnimationPlayer
onready var dialog_box = $DialoguePopup

const DIALOGUE_SPEED = 0.05
const DIALOGUE_PITCH = 2

func _ready():
	Jukebox.play_song("res://tunes/mainmenu.wav")
	dialog_box.init(cutscene_dialogue)
	dialog_box.start()
	
var done = false

func _input(event):
	if not done:
		return
	if event.is_action_pressed("accept"):
		finished()

var cutscene_dialogue = {
	"begin" : [
		"TEXT", "Long ago, there was a\nhappy puppy...", DIALOGUE_SPEED, "you", null, null, DIALOGUE_PITCH
	],
	"you" : [
		"TEXT", "That happy puppy...", DIALOGUE_SPEED, "was", null, null, DIALOGUE_PITCH
	],
	"was" : [
		"TEXT", "Was you!", DIALOGUE_SPEED, "life", null, null, DIALOGUE_PITCH
	],
	"life" : [
		"TEXT", "You lived a normal,\nsleepy, cozy life.", DIALOGUE_SPEED, "treats", null, null, DIALOGUE_PITCH
	],
	"treats" : [
		"TEXT", "Treats and snoozing were\nthe order of the day.", DIALOGUE_SPEED, "oneday", null, null, DIALOGUE_PITCH
	],
	"oneday" : [
		"TEXT", "But then one autumn day,\nsomething strange happened...", DIALOGUE_SPEED, "strange", null, null, DIALOGUE_PITCH
	],
	"strange" : [
		"TEXT", "A mysterious force took hold\nof your favorite ball...", DIALOGUE_SPEED, "ball", null, null, DIALOGUE_PITCH
	],
	"ball" : [
		"TEXT", "You followed it.", DIALOGUE_SPEED, "yard", null, null, DIALOGUE_PITCH
	],
	"yard" : [
		"TEXT", "You ran into the yard...", DIALOGUE_SPEED, "tree", null, null, DIALOGUE_PITCH
	],
	"tree" : [
		"TEXT", "Past the tree...", DIALOGUE_SPEED, "leaves", null, null, DIALOGUE_PITCH
	],
	"leaves" : [
		"TEXT", "Into the leaves...", DIALOGUE_SPEED, "fell", null, null, DIALOGUE_PITCH
	],
	"fell" : [
		"TEXT", "And then...", DIALOGUE_SPEED, "YOUFELL", null, null, DIALOGUE_PITCH
	],
	"YOUFELL" : [
		"TEXT", "You fell...", DIALOGUE_SPEED, "FALL", null, null, DIALOGUE_PITCH
	],
	"FALL" : [
		"TEXT", "", DIALOGUE_SPEED, null, [self, "title_card"], null, DIALOGUE_PITCH
	],
}

func title_card():
	Transition.go_to("res://Levels/0.0 Cave/Cave01.tscn")
	#animation.play("title")
	
func silence():
	Jukebox.stop()
	
func play_epic_tune():
	Jukebox.play_song("res://tunes/therealdog.wav")

func finished():
	Transition.go_to("res://Levels/0.0 Cave/Cave01.tscn")
