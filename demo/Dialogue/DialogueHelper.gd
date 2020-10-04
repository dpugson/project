extends Node

static func showDialogue(obj, dialogue):
	obj.get_tree().paused = true
	var popup = preload("res://Dialogue/DialoguePopup.tscn")
	var dialoguePopup = popup.instance()
	dialoguePopup.enchild(obj)
	dialoguePopup.init(dialogue)
	dialoguePopup.start()
