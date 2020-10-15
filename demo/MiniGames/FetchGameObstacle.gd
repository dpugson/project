extends YSort

onready var tween = $Tween
onready var obstacle = $Node2D
onready var origin = $origin
onready var end = $end

export(Vector2) var end_scale = null;
export(float) var speed = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	if end_scale == null:
		end_scale = obstacle.scale
	obstacle.scale = Vector2.ZERO
	
func set_origin(value):
	origin.position = value
	
func set_end(value):
	end.position = value

func play():
	tween.interpolate_property(
		obstacle,
		"position",
		origin.position,
		end.position,
		speed,
		Tween.TRANS_EXPO,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		obstacle,
		"scale",
		Vector2.ZERO,
		end_scale,
		speed,
		Tween.TRANS_EXPO,
		Tween.EASE_IN
	)
	tween.connect("tween_completed", self, "finish_up")
	tween.start()

func finish_up(_a, _b):
	self.queue_free()
