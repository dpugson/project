extends Camera2D

onready var upperLeft = $Limits/UpperLeft
onready var bottomRight = $Limits/BottomRight

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

export var fadeaway = 0.8
export var max_offset = Vector2(100, 75)
export var max_roll = 0.1
var shakiness = 0.0
var trauma_power = 1

func _process(delta):
	if shakiness > 0:
		shakiness = max(shakiness - fadeaway * delta, 0)
		shake()

func shake():
	var amount = pow(shakiness, trauma_power)
	noise_y += 0.5
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	limit_top = upperLeft.position.y
	limit_left = upperLeft.position.x


