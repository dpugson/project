extends Node

#TODO

export var SPEED_UP = 6000;
export var MAX_SPEED = 550;
export var SLOW_DOWN = 6000;

var speed = Vector2.ZERO

func move(thing, delta, input, animation_tree, blend_position_array):
	var normalized_input = input.normalized()
	if normalized_input != Vector2.ZERO:
		speed = speed.move_toward(normalized_input * MAX_SPEED, SPEED_UP * delta)
		for blend_position in blend_position_array:
			animation_tree.set(blend_position, normalized_input)
	else:
		speed = speed.move_toward(Vector2.ZERO, SLOW_DOWN * delta)
		
	speed = thing.move_and_slide(speed)
