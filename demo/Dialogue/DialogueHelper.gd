extends Node

static func showDialogue(obj, dialogue, show_top=false, callback=null):
	obj.get_tree().paused = true
	var popup = preload("res://Dialogue/DialoguePopup.tscn")
	var dialoguePopup = popup.instance()
	dialoguePopup.enchild(obj)
	dialoguePopup.init(dialogue)
	if show_top:
		dialoguePopup.top_mode()
	else:
		dialoguePopup.bottom_mode()
	if callback != null:
		dialoguePopup.connect("done", callback[0], callback[1])
	dialoguePopup.start()

static func showDialogueSimple(obj, raw_dialogue, speed=0.05, pitch=null, show_top=false, callback=null):
	var dialogue = {}
	var index = 0
	for line in raw_dialogue:
		var dialogue_key = str(index)
		if index == 0:
			dialogue_key = "begin"
		
		var next_dialogue = str(index + 1)
		if index == len(raw_dialogue) - 1:
			next_dialogue = null
		dialogue[dialogue_key] = [
			"TEXT", line, speed, next_dialogue, null, null, pitch
		]
		index += 1
	showDialogue(obj, dialogue, show_top, callback)
