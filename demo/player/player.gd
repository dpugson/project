extends KinematicBody2D

export var SPEED_UP = 6000;
export var MAX_SPEED = 550;
export var SLOW_DOWN = 6000;

enum {
	WALK,
	BARK,
	SWIM
}

var speed = Vector2.DOWN
var state = WALK
var stats = PlayerStats
var cutscene_mode: bool = false # for cutscenes
var allow_cutscene_bark: bool = false
export var cutscene_input: Vector2 = Vector2.DOWN

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

func _ready():
	stats.connect("out_of_health", self, "queue_free")
	lookbox.connect("saw_something", self, "set_speed_to_zero")
	bark_hitbox.knockback_vector = speed
	animation_tree.active = true

func _input(event):
	if stats.menu_allowed:
		if event.is_action_pressed("menu"):
			get_tree().paused = true
			var menu = Menu.instance()
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

func bark():
	animation_state.travel("bark")

func bark_complete():
	state = WALK
	
func check_for_bark_input():
	if cutscene_mode == true && not allow_cutscene_bark:
		return false
	else:
		return Input.is_action_just_pressed("bark")

func walk(_delta, input):	
	if input != Vector2.ZERO:
		animation_state.travel("walk")
	else:
		animation_state.travel("idle")
	if in_water():
		ripples.visible = true
		state = SWIM
	elif check_for_bark_input():
		state = BARK

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

func _on_HurtBox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
