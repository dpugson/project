extends KinematicBody2D

export var SPEED_UP = 6000;
export var MAX_SPEED = 550;
export var SLOW_DOWN = 6000;
export var TURBO_MAX_SPEED = 1500

enum {
	WALK,
	BARK,
	SWIM,
	TURBO_WARMUP,
	TURBO_DASHING
}

var speed = Vector2.DOWN
var dash_power = 1
var state = WALK
var stats = PlayerStats
var cutscene_mode: bool = false setget cutscene_mode_set # for cutscenes
var allow_cutscene_bark: bool = false
var turbo_input = Vector2.DOWN
var previous_input = Vector2.DOWN
export var cutscene_input: Vector2 = Vector2.ZERO
export(NodePath) var camera = null
var remote_transform: RemoteTransform2D = null

onready var player_animation = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var bark_hitbox = $HitBoxPivot/BarkHitBox
onready var hurtbox = $DoggoPivot/HurtBox
onready var lookbox = $DoggoPivot/LookBox
onready var Menu = preload("res://Items/Inventory.tscn")
onready var RealMenu = preload("res://MainMenu/RealMenu.tscn")
onready var water_detector = $WaterDetector
onready var ripples = $Ripples
onready var turbo_timer = $TurboTimer
onready var EffectHelper = preload("res://effects/EffectHelper.gd")

func _ready():
	stats.connect("out_of_health", self, "queue_free")
	lookbox.connect("saw_something", self, "set_speed_to_zero")
	bark_hitbox.knockback_vector = speed
	animation_tree.active = true

func cutscene_mode_set(value):
	cutscene_mode = value
	lookbox.disabled = value

func _input(event):
	if stats.menu_allowed:
		if event.is_action_pressed("menu"):
			get_tree().paused = true
			var menu = Menu.instance()
			menu.enchild(self)
		elif event.is_action_pressed("realmenu"):
			get_tree().paused = true
			var menu = RealMenu.instance()
			menu.enchild(self)

# HELPERS

func set_speed_to_zero():
	speed = Vector2.ZERO

func get_input(_delta) -> Vector2:
	if cutscene_mode:
		return cutscene_input
	else:
		var input = Vector2.ZERO
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input = input.normalized()
		if input != Vector2.ZERO:
			previous_input = input
		return input
	
func set_blend_positions(input):
	animation_tree.set("parameters/idle/blend_position", input)
	animation_tree.set("parameters/walk/blend_position", input)
	animation_tree.set("parameters/bark/blend_position", input)
	animation_tree.set("parameters/swim/blend_position", input)

func move(delta, input):
	if input != Vector2.ZERO:
		bark_hitbox.knockback_vector = input
		speed = speed.move_toward(input * MAX_SPEED, SPEED_UP * delta)
		set_blend_positions(input)
	else:
		speed = speed.move_toward(Vector2.ZERO, SLOW_DOWN * delta)
	
	if not cutscene_mode:
		speed = move_and_slide(speed)

func turbo_move(delta):
	speed = speed.move_toward(turbo_input * TURBO_MAX_SPEED, SPEED_UP * delta)
	speed = move_and_slide(speed)
	var slide_count = get_slide_count()
	if slide_count > 0:
		state = WALK
		if camera != null:
			get_node(camera).shakiness = 1
		for slide_index in range(slide_count):
			var obj = get_slide_collision(slide_index).collider
			if obj.has_method("get_slammed"):
				obj.call("get_slammed", dash_power)
		
	elif in_water():
		state = SWIM
		

func in_water():
	var areas = water_detector.get_overlapping_areas()
	if areas.size() > 0:
		return true
	else:
		return false

# STATES AND TRANSITIONS

func swim():
	if !in_water():
		ripples.visible = false
		state = WALK
	else:
		ripples.visible = true

func bark():
	animation_state.travel("bark")

func bark_complete():
	state = WALK
	
func check_for_bark_input():
	if cutscene_mode == true && not allow_cutscene_bark:
		return false
	else:
		return Input.is_action_just_pressed("bark")
		
func check_for_turbo_input():
	if cutscene_mode == true:
		return false
	else:
		if stats.check_bool("turbodash") or true:
			return Input.is_action_just_pressed("turbo")
		else:
			return false
		
func start_turbo_warmup():
	animation_state.travel("walk")
	player_animation.playback_speed = 200
	turbo_timer.start()
	turbo_input = previous_input

func walk(_delta, input):	
	if input != Vector2.ZERO:
		animation_state.travel("walk")
	else:
		animation_state.travel("idle")
	if in_water():
		state = SWIM
	elif check_for_bark_input():
		state = BARK
	elif check_for_turbo_input():
		state = TURBO_WARMUP
		start_turbo_warmup()
		

func _physics_process(delta):
	var input = get_input(delta)
	match state:
		WALK:
			walk(delta, input)
			move(delta, input)
		BARK:
			bark()
			speed *= .8
			move(delta, input)
		SWIM:
			animation_state.travel("swim")
			swim()
			move(delta, input)
		TURBO_WARMUP:
#			if check_for_turbo_input():
#				turbo_timer.stop()
#				state = WALK
			pass
		TURBO_DASHING:
#			if check_for_turbo_input():
#				state = WALK
			turbo_move(delta)

func _on_HurtBox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)

func _on_TurboTimer_timeout():
	state = TURBO_DASHING
