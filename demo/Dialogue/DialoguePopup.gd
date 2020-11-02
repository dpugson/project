extends CanvasLayer

export var SECONDS_PER_CHAR = 0.05

enum INPUT_TYPE {
	NONE,
	NEXT,
	DONE,
	CHOICE
}

export var cutscene_mode = false

var dialogue_index = "begin"
var character_index = 0
var waiting_for_input = INPUT_TYPE.NONE
var options_container = null

var dialogue = {
	"begin" : ["TEXT", "I bet you are wondering what I am going to say, huh?", 0.03, "1", null],
	"1" : ["TEXT", ". . .", 1, [["yes", "2"], ["no", "2"]], null, false],
	"2" : ["TEXT", "Well keep guessing!", 0.03, "begin"]
}

var seen = {}

var example_action = {
	"begin": ["ACTION", "Testing...", 0.03, null, [self, "queue_free"]]
}

var dialogue2 = {
	"begin" : ["TEXT", "Do you like potatoes?", 0.03, [["yes", "1"], ["no", "2", true]], null, "res://Dialogue/talking_heads/dog_neutral.png"],
	"1" : ["TEXT", "Interesting...", 0.3, "wow", null, false],
	"wow": ["TEXT", "Truly you are a doggo of culture.", 0.03, null],
	"2" : ["TEXT", "Tell me the truth!!!", 0.03, "begin", null, "res://Dialogue/talking_heads/dog_excited.png"]
}

signal print_next_character
signal done

onready var timer = $Timer
onready var nextButton = $Panel/MarginContainer/VBoxContainer/PlayerChoicesBottom/NextButton
onready var textLabel = $Panel/MarginContainer/VBoxContainer/DialogueHBoxContainer/Text
onready var playerChoices = $Panel/MarginContainer/VBoxContainer/PlayerChoicesBottom
onready var panel = $Panel
onready var portrait = $Panel2/CenterContainer/Portrait
onready var portrait_panel = $Panel2
onready var audio = $AudioStreamPlayer
onready var animation = $AnimationPlayer

func play_up_sound():
	audio.stream = load("res://tunes/dialogue/ack.wav")
	audio.play()
		
func play_down_sound():
	audio.stream = load("res://tunes/dialogue/done.wav")
	audio.play()

func enchild(thingy):
	var main = thingy.get_tree().current_scene
	main.add_child(self) 

func debugprint(text):
	if false:
		print(text)
		print_stack()

func _ready():
	init(dialogue)
	play_up_sound()
	portrait_panel.visible = false
	# warning-ignore:return_value_discarded
	self.connect("print_next_character", self, "print_next_character")
	start()
	
func bottom_mode():
	panel.margin_bottom = 1020
	panel.margin_right = 1820
	panel.margin_left = 95
	panel.margin_top = 640
#	portrait_panel.margin_left = 95
#	portrait_panel.margin_top = 322
#	portrait_panel.margin_right = 390
#	portrait_panel.margin_bottom = 603
	
func top_mode():
	panel.margin_bottom = 450
	panel.margin_right = 1820
	panel.margin_left = 95
	panel.margin_top = 70
#	portrait_panel.margin_left = 95
#	portrait_panel.margin_top = 725
#	portrait_panel.margin_right = 390
#	portrait_panel.margin_bottom = 1006

# Set up with the specified text, which should be an array
# of two element array pairs [tag, content].
func init(input_text):
	textLabel.text = ""
	dialogue_index = "begin"
	character_index = 0
	dialogue = input_text
	
func _input(event):
#	if event.is_action_pressed("accept") and !event.is_action_pressed("random_click"):
#		var focus = panel.get_focus_owner()
#		if focus != null and focus is Button:
#			focus.pressed = true
#			handle_button_click()
#			return
	if event.is_action_pressed("bark"):
		match waiting_for_input:
			INPUT_TYPE.NEXT:
				pass
			INPUT_TYPE.DONE:
				pass
			INPUT_TYPE.CHOICE:
				pass
			_:
				skip_to_end()

func handle_button_click():
	if cutscene_mode:
		# ignore input in cutscene mode
		return
	match waiting_for_input:
		INPUT_TYPE.NEXT:
			handle_next()
		INPUT_TYPE.DONE:
			stop()
		INPUT_TYPE.CHOICE:
			assert(false)
		_:
			skip_to_end() 

func handle_button_click2(next):
	if cutscene_mode:
		# ignore input in cutscene mode
		return
	if next == null:
		stop()
		return
	dialogue_index = next
	textLabel.text = ""
	waiting_for_input = false
	options_container.queue_free()
	print_next_character()

func handle_next():
	textLabel.text = ""
	waiting_for_input = false
	hide_prompt()
	print_next_character()
	
#func handle_choice():
#	for button in options_container.get_children():
#		if button.pressed:
#			if button.name == "END":
#				stop()
#				return
#			dialogue_index = button.name
#	textLabel.text = ""
#	waiting_for_input = false
#	options_container.queue_free()
#	print_next_character()
	
func option_should_not_reappear(option):
	return option.size() >= 3 and option[2] and seen.has(option[1])
	
func add_options(options):
	debugprint("add_options")
	options_container = HBoxContainer.new()
	playerChoices.add_child(options_container)
	var first = null
	for option in options:
		var prompt = option[0]
		var target = option[1]
		if option_should_not_reappear(option):
			continue
		var prompt_button = Button.new()
		prompt_button.text = prompt
		prompt_button.toggle_mode = true
		prompt_button.focus_mode = Control.FOCUS_ALL
		prompt_button.enabled_focus_mode = Control.FOCUS_ALL
		prompt_button.connect("pressed", self, "handle_button_click2", [target])
		options_container.add_child(prompt_button)
		if first == null:
			first = prompt_button
	first.grab_focus()
	
	
func clear_options():
	options_container.queue_free()
	
func show_prompt(label_text):
	debugprint("show_prompt")
	nextButton.text = label_text
	nextButton.visible = true
	nextButton.disabled = false
	nextButton.focus_mode = Control.FOCUS_ALL
	nextButton.enabled_focus_mode = Control.FOCUS_ALL
	nextButton.grab_focus()
	
func hide_prompt():
	nextButton.visible = false
	nextButton.disabled = true
	nextButton.focus_mode = Control.FOCUS_NONE
	nextButton.enabled_focus_mode = Control.FOCUS_NONE
	
func wait_for_next():
	show_prompt(">>")
	waiting_for_input = INPUT_TYPE.NEXT
	
func wait_for_done():
	show_prompt(">>")
	waiting_for_input = INPUT_TYPE.DONE
	
func wait_for_choice():
	waiting_for_input = INPUT_TYPE.CHOICE

func get_type():
	return get_row()[0]
	
func get_eval_stuff():
	return get_row()[1]

func get_text():
	return get_row()[1]
	
func get_wait_time():
	return get_row()[2]
	
func get_next_dialogue():
	return get_row()[3]
	
func get_action_info():
	var row = get_row()
	if row.size() < 5:
		return null
	else:
		return get_row()[4]
	
func get_picture():
	var row = get_row()
	if row.size() < 6:
		return null
	else:
		return row[5]
		
func get_pitch():
	var row = get_row()
	if row.size() < 7:
		return null #3
	else:
		return row[6]
	
func is_dialogue_at_end(index):
	return index == null
	
func get_row():
	return dialogue[dialogue_index]

func skip_to_end():
	debugprint("skip_to_end")
	timer.stop()
	if is_dialogue_at_end(dialogue_index):
		return 
#	if character_index >= get_text().length():
#		print("hrmmm")
#		return
	textLabel.text = get_text()
	advance_dialogue_counter_and_wait()
	
func is_dialogue_a_choice(index):
	return index is Array
	
func advance_dialogue_counter_and_wait():
	debugprint("advance_dialogue_counter_and_wait")
	seen[dialogue_index] = true
	character_index = 0
	dialogue_index = get_next_dialogue()
	if is_dialogue_at_end(dialogue_index):
		wait_for_done()
		return
	elif is_dialogue_a_choice(dialogue_index):
		add_options(dialogue_index)
		wait_for_choice()
		return
	else:
		wait_for_next()
		return
	
func print_next_character():
	if (character_index == 0):
		var picture = get_picture()
		if picture != null:
			if not picture is String:
				portrait.texture = null
				portrait_panel.visible = false
			else:
				portrait.texture = load(picture)
				portrait_panel.visible = true
		var action = get_action_info()
		if action != null:
			var obj = action[0]
			var function = action[1]
			if action.size() >= 3:
				obj.call(function, action[2])
			else:
				obj.call(function)
	if is_dialogue_at_end(dialogue_index):
		return
	if character_index >= get_text().length():
		advance_dialogue_counter_and_wait()
		return
	var character = get_text()[character_index]
	render_character_and_continue(character, get_wait_time())

func start():
	timer.wait_time = 0.15
	timer.start()
	
func stop():
	emit_signal("done")
	get_tree().set_deferred("paused", false)
	animation.play("stop")
	
const animalese_sounds = {
	'a': preload('res://tunes/AnimaleseSounds/a.wav'),
	'b': preload('res://tunes/AnimaleseSounds/b.wav'),
	'c': preload('res://tunes/AnimaleseSounds/c.wav'),
	'd': preload('res://tunes/AnimaleseSounds/d.wav'),
	'e': preload('res://tunes/AnimaleseSounds/e.wav'),
	'f': preload('res://tunes/AnimaleseSounds/f.wav'),
	'g': preload('res://tunes/AnimaleseSounds/g.wav'),
	'h': preload('res://tunes/AnimaleseSounds/h.wav'),
	'i': preload('res://tunes/AnimaleseSounds/i.wav'),
	'j': preload('res://tunes/AnimaleseSounds/j.wav'),
	'k': preload('res://tunes/AnimaleseSounds/k.wav'),
	'l': preload('res://tunes/AnimaleseSounds/l.wav'),
	'm': preload('res://tunes/AnimaleseSounds/m.wav'),
	'n': preload('res://tunes/AnimaleseSounds/n.wav'),
	'o': preload('res://tunes/AnimaleseSounds/o.wav'),
	'p': preload('res://tunes/AnimaleseSounds/p.wav'),
	'q': preload('res://tunes/AnimaleseSounds/q.wav'),
	'r': preload('res://tunes/AnimaleseSounds/r.wav'),
	's': preload('res://tunes/AnimaleseSounds/s.wav'),
	't': preload('res://tunes/AnimaleseSounds/t.wav'),
	'u': preload('res://tunes/AnimaleseSounds/u.wav'),
	'v': preload('res://tunes/AnimaleseSounds/v.wav'),
	'w': preload('res://tunes/AnimaleseSounds/w.wav'),
	'x': preload('res://tunes/AnimaleseSounds/x.wav'),
	'y': preload('res://tunes/AnimaleseSounds/y.wav'),
	'z': preload('res://tunes/AnimaleseSounds/z.wav'),
	'th': preload('res://tunes/AnimaleseSounds/th.wav'),
	'sh': preload('res://tunes/AnimaleseSounds/sh.wav'),
	' ': null,
	'.': preload('res://tunes/AnimaleseSounds/p.wav')
}

const PITCH_MULTIPLIER_RANGE := 0.3

func render_character_and_continue(character, wait_time):
	timer.wait_time = wait_time
	var pitch = get_pitch()
	if pitch != null:
		audio.stream = animalese_sounds.get(
			character.to_lower(), 
			null)
		audio.pitch_scale = pitch + (PITCH_MULTIPLIER_RANGE * randf())
		audio.play()
	textLabel.text += character
	character_index += 1
	timer.start()

func _on_Timer_timeout():
	emit_signal("print_next_character")
