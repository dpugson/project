extends Control

export var SECONDS_PER_CHAR = 0.05

enum INPUT_TYPE {
	NONE,
	NEXT,
	DONE,
	CHOICE
}

var dialogue_index = "begin"
var character_index = 0
var waiting_for_input = INPUT_TYPE.NONE
var options_container = null

var dialogue = {
	"begin" : ["TEXT", "I bet you are wondering what I am going to say, huh?", 0.03, "1"],
	"1" : ["TEXT", ". . .", 1, "2"],
	"2" : ["TEXT", "Well keep guessing!", 0.03, null]
}

var dialogue2 = {
	"begin" : ["TEXT", "Do you like potatoes?", 0.03, [["yes", "1"], ["no", "2"]]],
	"1" : ["TEXT", "Interesting...", 0.7, "wow"],
	"wow": ["TEXT", "Truly you are a doggo of culture.", 0.03, null],
	"2" : ["TEXT", "Weird!", 0.03, null]
}

signal print_next_character
signal printing_done

onready var timer = $Timer
onready var nextButton = $Panel/MarginContainer/VBoxContainer/PlayerChoicesBottom/NextButton
onready var textLabel = $Panel/MarginContainer/VBoxContainer/DialogueHBoxContainer/Text
onready var playerChoices = $Panel/MarginContainer/VBoxContainer/PlayerChoicesBottom

func _ready():
	init(dialogue2)
	self.connect("print_next_character", self, "print_next_character")
	start()

# Set up with the specified text, which should be an array
# of two element array pairs [tag, content].
func init(input_text):
	textLabel.text = ""
	dialogue_index = "begin"
	character_index = 0
	dialogue = input_text
	
func _input(event):
	if event.is_action_pressed("accept"):
		var focus = get_focus_owner()
		if focus != null:
			focus.pressed = true
			handle_button_click()
			return
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
	match waiting_for_input:
		INPUT_TYPE.NEXT:
			handle_next()
		INPUT_TYPE.DONE:
			queue_free()
		INPUT_TYPE.CHOICE:
			handle_next_choice()
		_:
			skip_to_end()

func handle_next():
	textLabel.text = ""
	waiting_for_input = false
	hide_prompt()
	print_next_character()
	
func handle_next_choice():
	for button in options_container.get_children():
		if button.pressed:
			dialogue_index = button.name
	textLabel.text = ""
	waiting_for_input = false
	options_container.queue_free()
	print_next_character()
	
func add_options(options):
	options_container = HBoxContainer.new()
	playerChoices.add_child(options_container)
	var first = null
	for option in options:
		var prompt = option[0]
		var target = option[1]
		var prompt_button = Button.new()
		prompt_button.name = target
		prompt_button.text = prompt
		prompt_button.toggle_mode = true
		prompt_button.focus_mode = Control.FOCUS_ALL
		prompt_button.enabled_focus_mode = Control.FOCUS_ALL
		prompt_button.connect("pressed", self, "handle_button_click")
		options_container.add_child(prompt_button)
		if first == null:
			first = prompt_button
	first.grab_focus()
	
	
func clear_options():
	options_container.queue_free()
	
func show_prompt(label_text):
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
	show_prompt("NEXT")
	waiting_for_input = INPUT_TYPE.NEXT
	
func wait_for_done():
	show_prompt("DONE")
	waiting_for_input = INPUT_TYPE.DONE
	
func wait_for_choice():
	waiting_for_input = INPUT_TYPE.CHOICE

func get_text():
	return get_row()[1]
	
func get_wait_time():
	return get_row()[2]
	
func get_next_dialogue():
	return get_row()[3]
	
func is_dialogue_at_end(index):
	return index == null
	
func get_row():
	return dialogue[dialogue_index]

func skip_to_end():
	timer.stop()
	if is_dialogue_at_end(dialogue_index):
		return 
	if character_index >= get_text().length():
		return
	textLabel.text = get_text()
	advance_dialogue_counter_and_wait()
	
func is_dialogue_a_choice(index):
	return index is Array
	
func advance_dialogue_counter_and_wait():
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
	if is_dialogue_at_end(dialogue_index):
		return
	if character_index >= get_text().length():
		advance_dialogue_counter_and_wait()
		return
	var character = get_text()[character_index]
	render_character_and_continue(character, get_wait_time())


func start():
	print_next_character()

func render_character_and_continue(character, wait_time):
	textLabel.text += character
	character_index += 1
	timer.wait_time = wait_time
	timer.start()

func _on_Timer_timeout():
	emit_signal("print_next_character")
