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
