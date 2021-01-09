extends Node2D

func _ready():
	pass
	
func _on_HurtBox_area_entered(area):
	print("!!!!")
	area.turn_on_spit()

func _on_HurtBox_area_exited(area):
	area.turn_off_spit()
