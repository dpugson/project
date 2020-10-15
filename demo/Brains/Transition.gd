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
	
func play_animation():
	animation.stop(true)
	animation.play("goto")

func _go_to():
	if target != null:
		# warning-ignore:unused_variable
		var result = get_tree().change_scene(target)

func unpause():
	get_tree().paused = false
	pass
