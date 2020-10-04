extends Node2D

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

export var speed = 5
export var start: Vector2 = Vector2.ZERO
export var end: Vector2 = Vector2.DOWN * 5

func play():
	sprite.position = start
	animation_state.travel("get_ready")
	animation_tree.active = true
	
func start_tween():
	print('tween')
	animation_state.travel("falling")
	var distance = start - end
	var time_to_fall = speed / distance.length()
	tween.interpolate_property(
		sprite, 
		"position", 
		sprite.position,
		end,
		time_to_fall
	)
	tween.start()
	
func finish_animation(_object, _key):
	animation_state.travel("splat")
