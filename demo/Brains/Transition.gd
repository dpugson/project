extends CanvasLayer

var target = null
onready var animation = $AnimationPlayer
onready var stats = PlayerStats

func go_to(scene, spawn_metadata=null):
	stats.spawn_metadata = spawn_metadata
	get_tree().paused = true
	animation.stop(true)
	animation.play("goto")
	self.target = scene

func _go_to():
	var result = get_tree().change_scene(target)
	print(result)

func unpause():
	get_tree().paused = false
