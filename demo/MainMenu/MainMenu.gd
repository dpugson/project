extends Control

onready var stats = PlayerStats

onready var reset_button = $HBoxContainer/Reset
onready var start = $HBoxContainer/Start
onready var current_location = $"Control/Current Location"
onready var level_lable = $Control/Level
onready var lab_friend = $Control/ProgressMarkers/labFriend

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")

func refresh_ui():
	stats.load_game(true) # force reload
	if stats.save_spot_name == null:
		reset()
		return
	if stats.save_spot_name == "Nowhere - You haven't started!":
		reset_button.disabled = true
		reset_button.visible = false
	var level = stats.world_state.get("level")
	level_lable.text = "Level " + str(level)
	current_location.text = stats.save_spot_name
	progress_markers()

func _ready():
	start.grab_focus()
	Jukebox.play_song("res://tunes/mainmenu.wav")
	stats.load_game()
	refresh_ui()

func progress_markers():
	if not stats.check_bool("ball_took_ball"):
		$Control/ProgressMarkers/ball.visible = false
	if not stats.check_bool("GOT_SWIMMING_CERT"):
		$Control/ProgressMarkers/swimFriends.visible = false
	if not stats.check_bool("alllabpuzzlesdone"):
		lab_friend.visible = false

func _on_Start_pressed():
	Transition.go_to(stats.save_spot_tscn, stats.save_spot_name)
	
var reset_dialogue = {
	"begin" : [
		"TEXT", "Are you sure you want to erase your current game?\nThis can't be undone!", 0.03,
		[["yes", "areusure"], ["no", null]]
	],
	"areusure" : [
		"TEXT", "Are you absolutely sure?", 0.03,
		[["no", null], ["yes", "yes"]]
	],
	"yes" : [
		"TEXT", "Your game has been reset.", 0.03, null,
		[self, "reset"]
	],
}

func reset_focus():
	start.grab_focus()

func _on_Reset_pressed():
	DialogueHelper.showDialogue(self, reset_dialogue, false, [self, "reset_focus"])
	
func reset():
	start.text = "NEW GAME"
	stats.world_state = {}
	stats.inventory = {}
	stats.world_state["level"] = 0
	stats.health = stats.max_health
	stats.G = 0
	stats.save_game(
		"Nowhere - You haven't started!", 
		"res://Levels/0.0 Cave/prologue.tscn")
	refresh_ui()


func _on_Quit_pressed():
	get_tree().quit()



func _on_LEVEL_2_DEMO_pressed():
	Transition.go_to("res://Levels/1.0 - Lab/Bathroom.tscn", "emerge_cutscene")
