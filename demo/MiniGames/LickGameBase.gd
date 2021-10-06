extends Node2D

onready var player = $LickGamePlayer
onready var cheer_up_bar = $Node2D/cheer_up
onready var cheer_up_timer = $CheerUpTimer
onready var percent_label = $Node2D/Percent
onready var timer = $Timer
onready var boss_animator = $BossAnimator
onready var label_animator = $LabelAnimator
onready var animator = $AnimationPlayer
onready var boss_shaker = $BossShaker
onready var boss = $boss

var ultimate_attack_phase = 0

var time = -1

var cheer_up_level: float = 0

signal round_over(won)

func update_percent_label():
	percent_label.text = ("%3.1f" % cheer_up_level) + "%"
	if true: #cheer_up_level >= 2:
		start_ultimate_attack()
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
	cheer_up_level = clamp(cheer_up_level + .5, 0, 100)
	cheer_up_bar.set_percentage(cheer_up_level)
	update_percent_label()

func start(input_time):
	animator.play("intro")
	self.time = input_time

func real_start():
	if self.time > 0:
		timer.wait_time = time
		timer.start()
	#boss_animator.play("basic")
	label_animator.play("default")

func start_ultimate_attack():
	match ultimate_attack_phase:
		0:
			start_ultimate_attack_phase_1()
		1:
			start_ultimate_attack_phase_2()

func start_ultimate_attack_phase_1():
	if ultimate_attack_phase == 1:
		return
	ultimate_attack_phase = 1
	boss_animator.stop()
	var tween = Tween.new()
	self.add_child(tween)
	tween.interpolate_property(
		player,
		"position",
		player.position,
		Vector2(977.972, 1375.72),
		1
	)
	tween.connect("tween_completed", self, "ultimate_attack_stage_two", [tween])
	tween.start()
	var tween2 = Tween.new()
	self.add_child(tween2)
	tween2.interpolate_property(
		boss,
		"position",
		boss.position,
		Vector2(975.182, 464.849),
		0.5
	)
	tween2.connect("tween_completed", self, "delete_tween", [tween2])
	tween2.start()
	
func start_ultimate_attack_phase_2():
	if cheer_up_level <= 30:
		print("HMMM")
		return
	print("hmm")
	ultimate_attack_phase = 2
	#animator.play("ultimate_attack_phase-2")

func delete_tween(_a, _b, tween):
	tween.queue_free()

func ultimate_attack_stage_two(_a, _b, tween):
	tween.queue_free()
	player.stop()
	animator.play("ultimate_attack")

func _on_Timer_timeout():
	emit_signal("round_over", false)

func start_damage():
	boss_shaker.play("shake")
