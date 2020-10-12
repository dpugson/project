extends CanvasLayer

onready var stats = PlayerStats
onready var animation = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("realmenu"):
		close()
	
func _on_Quit_pressed():
	get_tree().quit()

func _on_Cancel_pressed():
	close()
	
func close():
	get_tree().paused = false
	queue_free()
	
func enchild(obj):
	obj.add_child(self)
