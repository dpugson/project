extends Control

onready var Menu = preload("res://Items/Inventory.tscn")

onready var panel = $DecisionStuff/Panel

onready var main_choices = $DecisionStuff/MainChoices
onready var act_button = $DecisionStuff/MainChoices/Act
onready var item_button = $DecisionStuff/MainChoices/Item

onready var actions = $DecisionStuff/Actions
onready var act_back_button = $DecisionStuff/ActBackButton

onready var animation = $AnimationPlayer

onready var player_stats = $PlayerStats

func noop(action):
	print(action)

var battle_impl = {
	"handler" : [self, "noop"],
	"options" : [
		"Smell", "Bark", "Play Dead", "Roll Over"
	]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	act_button.grab_focus()
	init()
	
func init():
	var handler = battle_impl["handler"]
	for option in battle_impl["options"]:
		var button = Button.new()
		button.text = option
		button.connect("pressed", handler[0], handler[1], [option])
		actions.add_child(button)
	
func item_exit():
	panel.visible = true
	main_choices.visible = true
	item_button.grab_focus()
	player_stats.show()

func handle_item_click(menu, label, item, prev):
	print(label)
	print(item)
	menu.remove_item_from_list(label, prev)

func _on_Item_pressed():
	get_tree().paused = true
	var menu = Menu.instance()
	self.add_child(menu)
	menu.connect("tree_exited", self, "item_exit")
	menu.item_click_handler = [self, "handle_item_click"]
	main_choices.visible = false
	panel.visible = false
	player_stats.hide()

func _on_Act_pressed():
	animation.play("act_expand")
	act_back_button.grab_focus()
	for child in actions.get_children():
		child.grab_focus()
		break

func _on_ActBackButton_pressed():
	animation.play("act_contract")
	act_button.grab_focus()

