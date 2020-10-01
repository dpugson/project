extends KinematicBody2D

const MAX_SPEED = 500

var direction_index = 0
var input = Vector2.UP

onready var walking_thing = $WalkingThing
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

const BLENDS = [
	"parameters/idle/blend_position",
	"parameters/dog_walk/blend_position",
	"parameters/walk/blend_position"
]

const DIRECTIONS = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT
]

func _ready():
	animation_state.travel("dog_walk")
	animation_tree.active = true
	start_walk_in_circles()

func _physics_process(delta):
	walking_thing.move(self, delta, input, animation_tree, BLENDS)

func start_walk_in_circles():
	$WalkInCirclesTimer.wait_time = 0.8
	$WalkInCirclesTimer.start()
	pass

func _on_WalkInCirclesTimer_timeout():
	if (direction_index >= 4):
		direction_index = 0
	input = DIRECTIONS[direction_index]
	direction_index += 1
