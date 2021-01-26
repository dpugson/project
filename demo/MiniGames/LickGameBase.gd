extends Node2D

onready var player = $LickGamePlayer
onready var cheer_up_bar = $Node2D/cheer_up
onready var cheer_up_timer = $CheerUpTimer
onready var percent_label = $Node2D/Percent
onready var timer = $Timer
onready var boss_animator = $BossAnimator
onready var label_animator = $LabelAnimator
onready var animator = $AnimationPlayer

var time = 3

var cheer_up_level: float = 0

signal round_over(won)

func update_percent_label():
	percent_label.text = ("%3.1f" % cheer_up_level) + "%"
	if cheer_up_level >= 100:
		percent_label.modulate.g = 0
		percent_label.modulate.b = 0
		emit_signal("round_over", true)

func _ready():
	update_percent_label()
	
func _on_HurtBox_area_entered(_area):
	cheer_up_timer.start()
	player.turn_on_spit()

func _on_HurtBox_area_exited(_area):
	cheer_up_timer.stop()
	player.turn_off_spit()

func _on_CheerUpTimer_timeout():
	cheer_up_level = clamp(cheer_up_level + .1, 0, 100)
	cheer_up_bar.set_percentage(cheer_up_level)
	update_percent_label()

func start(time):
	animator.play("intro")
	self.time = time

func real_start():
	timer.wait_time = time
	timer.start()
	boss_animator.play("basic")
	label_animator.play("default")

func _on_Timer_timeout():
	emit_signal("round_over", false)
