extends YSort

onready var tween = $Tween
onready var origin = $origin
onready var end = $end

export(Vector2) var end_scale = Vector2(2, 2);
export(float) var speed = 5;

var obstacle = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(obstacle_scene):
	obstacle = obstacle_scene.instance()
	self.add_child(obstacle)
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
