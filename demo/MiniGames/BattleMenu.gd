extends Control

onready var Menu = preload("res://Items/Inventory.tscn")
onready var FetchGame = preload("res://MiniGames/FetchGameBase.tscn")

onready var panel = $DecisionStuff/Panel
onready var fetch_game_container = $FetchGameContainer
onready var fetch_game_controller = $FetchGameController

onready var main_choices = $DecisionStuff/MainChoices
onready var act_button = $DecisionStuff/MainChoices/Act
onready var item_button = $DecisionStuff/MainChoices/Item

onready var actions = $DecisionStuff/Actions
onready var act_back_button = $DecisionStuff/ActBackButton

onready var animation = $AnimationPlayer
onready var player_stats = $PlayerStats

onready var DialogueHelper = preload("res://Dialogue/DialogueHelper.gd")
onready var text_label = $DecisionStuff/Text
onready var next_button = $DecisionStuff/NextButton

#==================
# EXAMPLE MINIGAME
#==================

var round_info = {
	"obstacle_map": {
		"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
				"end_scale" : 10 },
	},
	"rounds": [
		["__*___", 3],
		["______", 1],
		["**____", 1],
		["_**___", 1],
		["__**__", 1],
		["____**", 4],
		["_****_", 3],
		["**__**", 5],
	]
}

func action_noop(action):
	var text = "You " + action + "...\n"
	show_text(text)

func item_noop(menu, _label, item, _prev):
	menu.close_menu()
	var text = "You show the " + str(item.name) + "...\nIt doesn't seem interested..."
	show_text(text)

func text_done():
	fetch_game_controller.play("go_to_game")
	launch_fetch_game(round_info, [self, "game_done"])

func game_done():
	fetch_game_controller.play("leave_game")
	animation.play("default")

var battle_impl = {
	"text_done_handler" : [self, "text_done"],
	"item_handler" : [self, "item_noop"],
	"action_handler" : [self, "action_noop"],
	"options" : [
		"TODO", "TODO 2", "TODO 3"
	]
}

#=================
# IMPLEMENTATION
#=================

func _ready():
	act_button.grab_focus()
	init(battle_impl)
	
func init(input_battle_impl):
	self.battle_impl = input_battle_impl
	var action_handler = battle_impl["action_handler"]
	
	# clear out actions
	for child in actions.get_children():
		child.queue_free()
	
	for option in battle_impl["options"]:
		var button = Button.new()
		button.text = option
		button.connect("pressed", action_handler[0], action_handler[1], [option])
		actions.add_child(button)
	
func item_exit():
	panel.visible = true
	main_choices.visible = true
	item_button.grab_focus()
	player_stats.show()

func _on_Item_pressed():
	var item_handler = battle_impl["item_handler"]
	get_tree().paused = true
	var menu = Menu.instance()
	self.add_child(menu)
	menu.connect("tree_exited", self, "item_exit")
	menu.item_click_handler = [item_handler[0], item_handler[1]]
	main_choices.visible = false
	panel.visible = false
	player_stats.hide()

func _on_Act_pressed():
	animation.play("show_actions")
	act_back_button.grab_focus()
	for child in actions.get_children():
		child.grab_focus()
		break

func _on_ActBackButton_pressed():
	animation.play("act_contract")
	act_button.grab_focus()

func launch_fetch_game(data, callback, item=null):
	var fetch_game = FetchGame.instance()
	fetch_game.auto_start = false
	fetch_game.round_info = data
	fetch_game_container.add_child(fetch_game)
	fetch_game.set_ball_texture(item)
	fetch_game_controller.play("go_to_game")
	fetch_game.connect("round_over", self, "fetch_game_complete_handler", [fetch_game, callback])
	fetch_game.start()

func fetch_game_complete_handler(fetch_game, callback):
	fetch_game.queue_free()
	fetch_game_controller.play("leave_game")
	act_button.grab_focus()
	if callback != null:
		callback[0].call(callback[1])

func show_dialogue(dialogue):
	DialogueHelper.showDialogue(self, dialogue, false, [self, "_on_NextButton_pressed"])

func show_text(text_to_show):
	text_label.text = text_to_show
	animation.play("show_text")
	next_button.grab_focus()

func _on_NextButton_pressed():
	var text_done_handler = battle_impl["text_done_handler"]
	text_done_handler[0].call(text_done_handler[1])
