extends Node2D

onready var stats = PlayerStats
onready var listen_seen_box = $green_friend_long_ear/ListenSeenBox
onready var prize_seen_box = $green_friend_long_arm/PrizeSeenBox
onready var prize_seen_box_collision = $green_friend_long_arm/PrizeSeenBox/CollisionShape2D
onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var animation = $AnimationPlayer
onready var gold = $green_friend_long_arm/OneG

export(String) var unique_name = ""
export(String, MULTILINE) var secret_text = "You whisper a very secret secret..."

signal done

func get_stats_name():
	return "got_g_from_" + unique_name

func _ready():
	if unique_name != null:
		if stats.check_bool(get_stats_name()):
			self.queue_free()

func _on_ListenSeenBox_seen(_obj):
	var dialogue = {
		"begin" : [
			"TEXT", "It's an ear... Do you whisper a secret?",
			0.02, [["Whisper a secret...", "secret"], ["Zip it", "nosecret"]], null, null, null
		],
		"secret" : [
			"TEXT", secret_text,
			0.02, null, [self, "secret_told"], null, null
		],
		"nosecret" : [
			"nosecret", "Better not. Loose lips sink ships!",
			0.02, null, null, null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue)

func secret_told():
	listen_seen_box.queue_free()
	animation.play("lower_ear")

func raise_arm():
	animation.play("raise_arm")

func arm_up():
	prize_seen_box_collision.disabled = false

func _on_PrizeSeenBox_seen(_obj):
	prize_seen_box.queue_free()
	var dialogue = {
		"begin" : [
			"TEXT", "A delightful and unexpected reward... 1G!",
			0.02, null, [self, "get_one_g"], null, null
		],
	}
	DialogueHelper.showDialogue(self, dialogue)

func get_one_g():
	stats.world_state[get_stats_name()] = true
	stats.G += 1
	gold.queue_free()
	animation.play("lower_arm")
	emit_signal("done")
