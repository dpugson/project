extends CanvasLayer

onready var stats = PlayerStats

onready var reset_button = $Control/Reset
onready var start = $Control/Start
onready var current_location = $"Control/Current Location"
onready var level_lable = $Control/Level

func refresh_ui():
	var level = stats.world_state.get("level")
	if level == null:
		reset_button.disabled = true
		reset_button.visible = false
		reset()
	level = stats.world_state.get("level")
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

func _on_Start_pressed():
	Transition.go_to(stats.save_spot_tscn, stats.save_spot_name)

func _on_Reset_pressed():
	reset()
	refresh_ui()
	
func reset():
	start.text = "NEW GAME"
	stats.save_spot_name = "Nowhere - You haven't started!"
	stats.save_spot_tscn = "res://Levels/0.0 Cave/prologue.tscn"
	stats.world_state = {}
	stats.inventory = {}
	stats.world_state["level"] = 0
	stats.save_game(
		"Nowhere - You haven't started!", 
		"res://Levels/0.0 Cave/prologue.tscn")
