extends Area2D

onready var collisionShape = $CollisionShape2D
onready var timer = $Timer

signal saw_something
signal moving_furniture
signal not_moving_furniture
signal rotated_furniture_clockwise
signal rotated_furniture_counterclockwise

export(bool) var disabled = false

var state = LOOK_MODE

enum {
	LOOK_MODE,
	MOVE_FURNITURE_MODE
}

func look_at_things():
	var areas = self.get_overlapping_areas()
	if areas.size() >= 1:
		if areas[0].has_method("get_seen"):
			emit_signal("saw_something")
			areas[0].get_seen(self)

func get_furniture():
	var areas = self.get_overlapping_areas()
	if areas.size() >= 1:
		return areas[0]
	else:
		return null

func rotate_furniture_clockwise():
	var areas = self.get_overlapping_areas()
	if areas.size() >= 1:
		var furniture = areas[0]
		if furniture.has_method("rotate"):
			furniture.rotate("clockwise")
			emit_signal("rotated_furniture_clockwise")

func rotate_furniture_counterclockwise():
	var areas = self.get_overlapping_areas()
	if areas.size() >= 1:
		var furniture = areas[0]
		if furniture.has_method("rotate"):
			furniture.rotate("counterclockwise")
			emit_signal("rotated_furniture_counterclockwise")

func _input(event):
	if not disabled:
		if event.is_action_pressed("look"):
			look_at_things()
		# furniture stuff!! WIP
#		if event.is_action_pressed("look"):
#			timer.start()
#		elif event.is_action_released("look"):
#			timer.stop()
#			match state:
#				LOOK_MODE:
#					look_at_things()
#				MOVE_FURNITURE_MODE:
#					state = LOOK_MODE
#					emit_signal("not_moving_furniture")
#		else:
#			match state:
#				MOVE_FURNITURE_MODE:
#					handle_furniture_move_action(event)
#				_:
#					pass

func calculate_furniture_direction(furniture):
	var direction = (furniture.global_position - global_position).normalized().rotated(-0.785398)
	if direction.x > 0:
		if direction.y > 0:
			return "UP"
		else:
			return "LEFT"
	else:
		if direction.y <= 0:
			return "DOWN"
		else: 
			return "RIGHT"

func push_furniture_down():
	pass
func pull_furniture_down():
	pass
func pull_furniture_right():
	pass
func push_furniture_right():
	pass
func pull_furniture_left():
	pass
func push_furniture_left():
	pass
func push_furniture_up():
	pass
func pull_furniture_up():
	pass

func get_furniture_action_map(direction):
	var maps = {
		"UP" : {
			"ui_right": "rotate_furniture_clockwise",
			"ui_left": "rotate_furniture_counterclockwise",
			"ui_down": "push_furniture_down",
			"ui_up": "pull_furniture_up"
		},
		"LEFT" : {
			"ui_right": "push_furniture_right",
			"ui_left": "pull_furniture_left",
			"ui_down": "rotate_furniture_counterclockwise",
			"ui_up": "rotate_furniture_clockwise"
		},
		"RIGHT" : {
			"ui_right": "pull_furniture_right",
			"ui_left": "push_furniture_left",
			"ui_down": "rotate_furniture_clockwise",
			"ui_up": "rotate_furniture_counterclockwise"
		},
		"DOWN" : {
			"ui_right": "rotate_furniture_counterclockwise",
			"ui_left": "rotate_furniture_clockwise",
			"ui_down": "pull_furniture_up",
			"ui_up": "push_furniture_down"
		}
	}
	return maps[direction]

func handle_furniture_move_action(event):
	var furniture = get_furniture()
	if furniture == null:
		return
	var direction = null
	for ui_direction in ["ui_left", "ui_up", "ui_down", "ui_right"]:
		if event.is_action_pressed(ui_direction):
			direction = ui_direction
			break
	if direction != null:
		var furniture_direction = calculate_furniture_direction(furniture)
		var action_map = get_furniture_action_map(furniture_direction)
		self.call(action_map[direction])

func _on_Timer_timeout():
	pass
	#state = MOVE_FURNITURE_MODE
	#emit_signal("moving_furniture")
