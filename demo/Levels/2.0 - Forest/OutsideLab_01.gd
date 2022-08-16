extends Node2D

onready var stats = PlayerStats
onready var player = $YSort/player
onready var labSP = $LabSP
onready var rightSP = $RightSP
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var camera = $PuppyCamera
onready var robot = $YSort/RobotFollower
onready var animation = $AnimationPlayer
onready var hide_spot = $HideSpot
onready var savestar = $BGStuff/SaveStar
var old_direction = null

onready var robot_remote_transform = $YSort/RobotFollower/RemoteTransform2D
onready var shrine_remote_transform = $YSort/shrine_hill/RemoteTransform2D

func _ready():
	var player_position = labSP.global_position
	var orientation = Vector2.RIGHT
	#Jukebox.play_song("res://tunes/forest/forest_theme_lofi.wav")
	Jukebox.play_song("res://tunes/puzzletime.wav")
	#stats.spawn_metadata = "cutscene_leaving_lab"
	robot.set_dialogue_list([
		robot.say("It's beautiful outside, isn't it?"),
		#robot.silent("...\nThe robot seems to be in silent contemplation.")
	])
	robot.animated_sprite.frame = 0
	if not stats.check_bool("robot_following"):
		# get rid of robot
		robot.hidden_mode()
		robot.global_position = hide_spot.global_position
	match stats.spawn_metadata:
		"The Forest - Labside Meadow":
			player_position = savestar.global_position
			orientation = Vector2.DOWN
		"cutscene_leaving_lab":
			player.cutscene_mode = true
			player_position = labSP.global_position
			orientation = Vector2.RIGHT
			cutscene_leaving_lab()
		"lab":
			player_position = labSP.global_position
			orientation = Vector2.RIGHT
		"right":
			player_position = rightSP.global_position
			var robot_position = player_position
			robot_position.x -= 200
			robot.global_position = player_position
			orientation = Vector2.DOWN
	stats.spawn_player(
		player, null, 
		"../../../PuppyCamera", player_position, orientation)

func cutscene_leaving_lab():
	animation.play("cutscene_leaving_lab")

func admire_beauty():
	var dialogue = {
		"begin" : [
			"TEXT", "Wow...", robot.SPEED, 
			"2", null, null, robot.PITCH
		],
		"2" : [
			"TEXT", "What a beautiful day!!!", robot.SPEED, 
			"3", [robot, "down"], null, robot.PITCH
		],
		"3" : [
			"TEXT", "The crisp air!!! The colorful leaves!!!", robot.SPEED, 
			"4", [robot, "up"], null, robot.PITCH
		],
		"4" : [
			"TEXT", "You know... This is actually the first time I've ever left the lab!\nIt's refreshing!", robot.SPEED, 
			null, [robot, "right"], null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "free_player"])

func free_player():
	player.cutscene_mode = false
	if old_direction != null:
		robot.animated_sprite.animation = old_direction
		old_direction = null

func _on_PuzzleHouseTZ_transition_triggered():
	if stats.check_bool("robot_following") and not stats.check_bool("robot_said_ill_wait"):
		stats.set_bool("robot_said_ill_wait")
		var dialogue = {
			"begin" : [
				"TEXT", "Heading back inside, puppy?", robot.SPEED, 
				"2", null, null, robot.PITCH
			],
			"2" : [
				"TEXT", "It's so beautiful out, I'll wait out here!", robot.SPEED, 
				null, null, null, robot.PITCH
			]
		}
		robot.hidden_mode()
		robot.animated_sprite.frame = 0
		robot.animated_sprite.playing = false
		DialogueHelper.showDialogue(self, dialogue, false, [self, "go_to_giftshop"])
	else:
		go_to_giftshop()

func go_to_giftshop():
	Transition.go_to("res://Levels/1.0 - Lab/GiftShop.tscn", "top")

func _on_RightTZ_transition_triggered():
	Transition.go_to("res://Levels/2.0 - Forest/OutsideLab_02.tscn", "left")

func _on_TopTZ_transition_triggered():
	pass # Replace with function body.

func clear_focus():
	camera.smoothing_speed = 1
	robot_remote_transform.remote_path = ""
	shrine_remote_transform.remote_path = ""
	if player.remote_transform != null:
		player.remote_transform.remote_path = ""

func give_robot_focus():
	clear_focus()
	robot_remote_transform.remote_path = "../../../PuppyCamera"

func give_player_focus():
	clear_focus()
	camera.smoothing_speed = 5
	player.remote_transform.remote_path = "../../../PuppyCamera"

func give_shrine_focus():
	clear_focus()
	shrine_remote_transform.remote_path = "../../../PuppyCamera"

var times = 0
func get_timer(next):
	times = 0
	var timer = Timer.new()
	timer.connect("timeout", self, "wait_for_catchup", [timer, next])
	timer.wait_time = 0.1
	return timer

func _on_ShrineSeenBox_seen(_obj):
	if stats.check_bool("robot_following") && not stats.check_bool("seen_rat_shrine"):
		# Wait until our friend is near
		stats.set_bool("seen_rat_shrine")
		player.cutscene_mode = true
		var timer = get_timer("robot_shrine_dialogue")
		self.add_child(timer)
		timer.start()
	else:
		plain_shrine_dialogue()

func wait_for_catchup(timer, next):
	times += 1
	if times == 6:
		timer.queue_free()
		self.call(next)
		return
	if robot.global_position.distance_to(player.global_position) <= robot.DISTANCE_FROM_PLAYER:
		timer.queue_free()
		self.call(next)
		return

func plain_shrine_dialogue():
	var dialogue = {
		"begin" : [
			"TEXT", "An old wooden shrine.", robot.SPEED, 
			"2", null, null, null
		],
		"2" : [
			"TEXT", "It smells calming and dusty.", robot.SPEED, 
			null, null, null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "free_player"])

func robot_shrine_dialogue():
	old_direction = robot.animated_sprite.animation
	robot.animated_sprite.animation = "up"
	var dialogue = {
		"begin" : [
			"TEXT", "A charming little shrine, don't you think?", robot.SPEED, 
			"2", null, null, robot.PITCH
		],
		"2" : [
			"TEXT", "Rattus rattus! Common name: the house rat.", robot.SPEED, 
			"3", null, null, robot.PITCH
		],
		"3" : [
			"TEXT", "A symbol of perserverance, and of thriving in the face\nof adversity.", robot.SPEED, 
			"4", null, null, robot.PITCH
		],
		"4" : [
			"TEXT", "The little guys are rather inspirational,\nif you think about it!", robot.SPEED, 
			"5", null, null, robot.PITCH
		],
		"5" : [
			"TEXT", "Or should I have said 'rat-er inspi-rat-tional'? Ho ho ho!", robot.SPEED, 
			null, null, null, robot.PITCH
		],
	}
	DialogueHelper.showDialogue(self, dialogue, false, [self, "free_player"])
