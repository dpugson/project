extends Node2D

onready var animation = $AnimationPlayer

enum SIDE {
	LEFT = 0,
	RIGHT = 1
}

var pulled = false
export(SIDE) var side = SIDE.LEFT

signal pulled(side)

func _ready():
	match side:
		SIDE.LEFT:
			animation.play("left")
			side = SIDE.LEFT
		SIDE.RIGHT:
			animation.play("right")
			side = SIDE.RIGHT

func _on_SeenBox_seen(_seen):
	match side:
		SIDE.LEFT:
			animation.stop()
			animation.play("flip_lr")
			side = SIDE.RIGHT
		SIDE.RIGHT:
			animation.stop()
			animation.play("flip_rl")
			side = SIDE.LEFT

func pull_complete():
	emit_signal("pulled", side)
