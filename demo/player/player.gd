extends KinematicBody2D

export var SPEED_UP = 6000;
export var MAX_SPEED = 500;
export var SLOW_DOWN = 6000;
export var TURBO_MAX_SPEED = 1500
export var TURBO_SPEED_UP = 60000;

enum {
	WALK,
	BARK,
	SWIM,
	TURBO_WARMUP,
	TURBO_DASHING,
	MOVING_FURNITURE,
	GRABSHOT_AIMING,
	GRABSHOT_LAUNCHING,
	GRABSHOT_RETURNING,
	GRABSHOT_ZOOMING
}

var speed = Vector2.DOWN
var dash_power = 1
var state = WALK
var stats = PlayerStats
# the global positions of the grabshot elements
# at the point of a grab
var grab_point = null
var grab_point_chain = null
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
onready var bark_hitbox_collision = $HitBoxPivot/BarkHitBox/CollisionShape2D
onready var hurtbox = $DoggoPivot/HurtBox
onready var lookbox = $DoggoPivot/LookBox
onready var Menu = preload("res://Items/Inventory.tscn")
onready var RealMenu = preload("res://MainMenu/RealMenu.tscn")
onready var water_detector = $WaterDetector
onready var ripples = $Ripples
onready var turbo_timer = $TurboTimer
onready var EffectHelper = preload("res://effects/EffectHelper.gd")
onready var dog_animation_sprite = $DogAnimation
onready var furniture_turn_timer = $MoveFurnitureRotationTimer
onready var costume_sprites = $Costumes/CostumeSprites
onready var cameraOffset = $CameraOffset
onready var hatanimator = $DogAnimation/hat/hatanimator
onready var hat_sprite = $DogAnimation/hat/Sprite
onready var hat_node = $DogAnimation/hat
onready var grabshot = $grabshot_center
onready var grabshot_chain = $grabshot_center/chain/TextureRect
onready var grabshot_tip = $grabshot_center/chain/grabshot_tip
onready var grab_detector = $grabshot_center/chain/grabshot_tip/grab_detector
onready var grabshot_player_goto_point = $grabshot_center/chain/grabshot_tip/PlayerGoToPoint
onready var grabshot_timer = $grabshot_center/grabshot_timer
onready var grabshot_audio_player = $grabshot_center/grabshot_audio_animator

func _ready():
	stats.set_bool("grabshot")
	
	stats.connect("out_of_health", self, "queue_free")
	lookbox.connect("saw_something", self, "set_speed_to_zero")
	grab_detector.connect("hit", self, "grabshot_set_grab_point")
	bark_hitbox.knockback_vector = speed
	bark_hitbox_collision.disabled = true
	animation_tree.active = true
	stats.connect("put_on_hat", self, "set_hat")
	set_hat()
	
	grabshot.visible = false

func set_hat():
	var hat = stats.world_state.get("HAT", null)
	if hat != null:
		hat_sprite.texture = load(hat)
		hat_node.visible = true
	else:
		hat_node.visible = false

func cutscene_mode_set(value):
	cutscene_mode = value
	lookbox.disabled = value

func _input(event):
	if stats.menu_allowed and not cutscene_mode:
		if event.is_action_pressed("menu"):
			get_tree().paused = true
			var menu = Menu.instance()
			menu.enchild(self)
		elif event.is_action_pressed("realmenu"):
			get_tree().paused = true
			var menu = RealMenu.instance()
			menu.enchild(self)

# HELPERS
#
#func calculate_direction(input):
#	var direction = input.rotated(-0.785398)
#	if direction.x > 0:
#		if direction.y > 0:
#			return "down"
#		else:
#			return "right"
#	else:
#		if direction.y <= 0:
#			return "up"
#		else: 
#			return "left"
#
#func update_costume(input):
#	if input == Vector2.ZERO:
#		return
#	var direction = calculate_direction(input)
#	for animated_costume_sprite in costume_sprites.get_children():
#		animated_costume_sprite.animation = direction

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

func turbo_move(delta, input):
	if stats.check_bool("CYBERNETICALLY_ENHANCED_TURBO"):
		if input != Vector2.ZERO:
			turbo_input = input
			set_blend_positions(turbo_input)
	speed = speed.move_toward(turbo_input * TURBO_MAX_SPEED, TURBO_SPEED_UP * delta)
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
	if not areas.empty():
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
		if stats.check_bool("turbodash"):
			return Input.is_action_just_pressed("turbo")
		else:
			return false

func check_for_grabshot_input():
	if cutscene_mode == true:
		return false
	else:
		if stats.check_bool("grabshot"):
			return Input.is_action_just_pressed("grabshot")
		else:
			return false
			
func check_for_grabshot_released_input():
	if cutscene_mode == true:
		return false
	else:
		if stats.check_bool("grabshot"):
			return Input.is_action_just_released("grabshot")
		else:
			return false
		
func start_turbo_warmup():
	animation_state.travel("walk")
	player_animation.playback_speed = 200
	turbo_timer.start()
	turbo_input = previous_input

func walk(_delta, input):	
	if input != Vector2.ZERO:
		grabshot.visible = false
		hatanimator.play("bounce")
		animation_state.travel("walk")
	else:
		hatanimator.play("default")
		animation_state.travel("idle")
	if in_water():
		state = SWIM
	elif check_for_bark_input():
		state = BARK
	elif check_for_turbo_input():
		state = TURBO_WARMUP
		start_turbo_warmup()
	elif check_for_grabshot_input():
		if ![GRABSHOT_AIMING, GRABSHOT_LAUNCHING, GRABSHOT_RETURNING, GRABSHOT_ZOOMING].has(state):
			state = GRABSHOT_AIMING
			speed = Vector2.ZERO

func _physics_process(delta):
	var input = get_input(delta)
	#update_costume(input)
	match state:
		WALK:
			walk(delta, input)
			move(delta, input)
		BARK:
			grabshot.visible = false
			bark()
			speed *= .8
			move(delta, input)
		SWIM:
			grabshot.visible = false
			animation_state.travel("swim")
			swim()
			move(delta, input)
		TURBO_WARMUP:
			grabshot.visible = false
#			if check_for_turbo_input():
#				turbo_timer.stop()
#				state = WALK
			pass
		TURBO_DASHING:
			grabshot.visible = false
#			if check_for_turbo_input():
#				state = WALK
			turbo_move(delta, input)
		GRABSHOT_AIMING:
			animation_state.travel("idle")
			grabshot.visible = true
			grabshot_wait()
		GRABSHOT_LAUNCHING:
			grabshot_launch()
		GRABSHOT_RETURNING:
			grabshot_retract()
		GRABSHOT_ZOOMING:
			grabshot_zoom()

const GRABSHOT_MIN_LEN = 25
const GRABSHOT_MAX_LEN = 600
const GRABSHOT_SPEED = 20
const GRABSHOT_ZOOM_SPEED = 40

func grabshot_wait():
	if check_for_grabshot_released_input():
		grab_detector.disabled = false
		grabshot_audio_player.play("launch")
		state = GRABSHOT_LAUNCHING

onready var original_chain_rect_position = grabshot_chain.rect_position
onready var original_chain_size = grabshot_chain.rect_size
onready var original_grabshot_tip_position = grabshot_tip.position
func reset_grabshot():
	grabshot_chain.rect_position = original_chain_rect_position
	grabshot_chain.rect_size = original_chain_size
	grabshot_tip.position = original_grabshot_tip_position

func grabshot_launch():
	if grabshot_chain.rect_size.x >= GRABSHOT_MAX_LEN:
		state = GRABSHOT_RETURNING
	else:
		grabshot_chain.rect_size.x += GRABSHOT_SPEED
		grabshot_chain.rect_position.x -= GRABSHOT_SPEED
		grabshot_tip.position.x -= GRABSHOT_SPEED

func grabshot_set_grab_point():
	grabshot_audio_player.play("hit")
	grab_detector.disabled = true
	state = GRABSHOT_ZOOMING
	grab_point = grabshot_tip.global_position
	grab_point_chain = grabshot_chain.rect_global_position

func grabshot_retract():
	if grabshot_chain.rect_size.x <= GRABSHOT_MIN_LEN:
		grabshot_audio_player.stop()
		state = WALK
	else:
		grabshot_chain.rect_size.x -= GRABSHOT_SPEED
		grabshot_chain.rect_position.x += GRABSHOT_SPEED
		grabshot_tip.position.x += GRABSHOT_SPEED

func grabshot_zoom():
	if self.global_position.distance_to(grabshot_player_goto_point.global_position) <= 10:
		grabshot_audio_player.stop()
		reset_grabshot()
		state = WALK
		return
	else:
		grabshot_chain.rect_size.x -= GRABSHOT_ZOOM_SPEED
		grabshot_chain.rect_global_position = grab_point_chain
		grabshot_tip.global_position = grab_point
		self.global_position = self.global_position.move_toward(
			grabshot_player_goto_point.global_position,
			GRABSHOT_ZOOM_SPEED)

func _on_HurtBox_area_entered(_area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)

func _on_TurboTimer_timeout():
	state = TURBO_DASHING

func _on_LookBox_moving_furniture():
	dog_animation_sprite.scale = Vector2(1, .9)
	dog_animation_sprite.position += Vector2(0, 10)
	cutscene_mode = true
	
func _on_LookBox_not_moving_furniture():
	dog_animation_sprite.scale = Vector2(1, 1)
	dog_animation_sprite.position += Vector2(0, -10)
	cutscene_mode = false

func _on_LookBox_rotated_furniture_clockwise():
	dog_animation_sprite.rotation_degrees -= 20
	furniture_turn_timer.start()

func _on_LookBox_rotated_furniture_counterclockwise():
	dog_animation_sprite.rotation_degrees += 20
	furniture_turn_timer.start()

func _on_MoveFurnitureRotationTimer_timeout():
	dog_animation_sprite.rotation = 0

func _exit_tree():
	stats.disconnect("put_on_hat", self, "set_hat")

