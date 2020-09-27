extends Node

static func place_effect(class_to_place_effect_on, effect_class):
	var effect = effect_class.instance()
	class_to_place_effect_on.get_parent().add_child(effect)
	effect.global_position = class_to_place_effect_on.global_position

static func place_effect_global(class_to_place_effect_on, effect_class):
	var main = class_to_place_effect_on.get_tree().current_scene
	var effect = effect_class.instance()
	main.add_child(effect)
	effect.global_position = class_to_place_effect_on.global_position
