extends CanvasLayer

var target = null
onready var animation = $AnimationPlayer
onready var stats = PlayerStats

func go_to(player, scene):
	get_tree().paused = true
	animation.play("transition")
	self.target = scene

func _go_to():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(target)

func unpause():
	get_tree().paused = false
