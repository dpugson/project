extends Camera2D

onready var upperLeft = $Limits/UpperLeft
onready var bottomRight = $Limits/BottomRight

# Called when the node enters the scene tree for the first time.
func _ready():
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	limit_top = upperLeft.position.y
	limit_left = upperLeft.position.x
