extends Node

static func place_effect(class_to_place_effect_on, effect_class, location=null, callback=null):
	var effect = effect_class.instance()
	class_to_place_effect_on.get_parent().add_child(effect)
	if location != null:
		effect.global_position = location
	else:
		effect.global_position = class_to_place_effect_on.global_position
	if callback != null:
		effect.connect("done", callback[0], callback[1])

static func place_effect_global(class_to_place_effect_on, effect_class, location=null, callback=null):
	var main = class_to_place_effect_on.get_tree().current_scene
	var effect = effect_class.instance()
	main.add_child(effect)
	if location != null:
		effect.global_position = location
	else:
		effect.global_position = class_to_place_effect_on.global_position
	if callback != null:
		effect.connect("done", callback[0], callback[1])
