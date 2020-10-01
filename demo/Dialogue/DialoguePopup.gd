extends Control

export var SECONDS_PER_CHAR = 0.05

enum INPUT_TYPE {
	NONE,
	NEXT,
	DONE
}

var dialogue_index = 0
var character_index = 0
var waiting_for_input = INPUT_TYPE.NONE

var dialogue = [
	["TEXT", "I bet you are wondering what I am going to say, huh?", 0.03],
	["TEXT", ". . .", 1],
	["TEXT", "Well keep guessing!", 0.03]
]

signal print_next_character
signal printing_done

onready var timer = $Timer
onready var nextButton = $Panel/MarginContainer/VBoxContainer/PlayerChoicesBottom/NextButton
onready var textLabel = $Panel/MarginContainer/VBoxContainer/DialogueHBoxContainer/Text

func _ready():
	init(dialogue)
	self.connect("print_next_character", self, "print_next_character")
	start()

# Set up with the specified text, which should be an array
# of two element array pairs [tag, content].
func init(input_text):
	textLabel.text = ""
	dialogue_index = 0
	character_index = 0	
	dialogue = input_text
	
func _input(event):
	if event.is_action_pressed("accept"):
		match waiting_for_input:
			INPUT_TYPE.NEXT:
				handle_next()
			INPUT_TYPE.DONE:
				queue_free()
			_:
				skip_to_end()
			
func handle_next():
	print("accepting click")
	print(character_index, dialogue_index)
	textLabel.text = ""
	waiting_for_input = false
	hide_prompt()
	print_next_character()
	
func show_prompt(label_text):
	nextButton.text = label_text
	nextButton.visible = true
	nextButton.disabled = false
	nextButton.enabled_focus_mode = Control.FOCUS_ALL
	
func hide_prompt():
	nextButton.visible = false
	nextButton.disabled = true
	nextButton.enabled_focus_mode = Control.FOCUS_NONE
	
func wait_for_next():
	show_prompt("NEXT")
	waiting_for_input = INPUT_TYPE.NEXT
	
func wait_for_done():
	show_prompt("DONE")
	waiting_for_input = INPUT_TYPE.DONE
	
func skip_to_end():
	timer.stop()
	if (dialogue_index >= dialogue.size()):
		return
	var row = dialogue[dialogue_index]
	var text = row[1]
	var wait_time = row[2] 
	if character_index >= text.length():
		return
	textLabel.text = text
	advance_dialogue_counter_and_wait()
	
func advance_dialogue_counter_and_wait():
	character_index = 0
	dialogue_index += 1
	if dialogue_index >= dialogue.size():
		wait_for_done()
		return
	else:
		wait_for_next()
		return
	
	
func print_next_character():
	if (dialogue_index >= dialogue.size()):
		return
	var row = dialogue[dialogue_index]
	var text = row[1]
	var wait_time = row[2] 
	if character_index >= text.length():
		advance_dialogue_counter_and_wait()
		return
	var character = text[character_index]
	render_character_and_continue(character, wait_time)


func start():
	print_next_character()

func render_character_and_continue(character, wait_time):
	textLabel.text += character
	character_index += 1
	timer.wait_time = wait_time
	timer.start()

func _on_Timer_timeout():
	emit_signal("print_next_character")
