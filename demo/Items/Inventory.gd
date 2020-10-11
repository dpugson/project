extends CanvasLayer

onready var stats = PlayerStats
onready var items_list = $List/MarginContainer/VBoxContainer/ScrollContainer/ItemsList
onready var item_picture = $Description/MarginContainer/VBoxContainer/ItemPicture
onready var item_description = $Description/MarginContainer/VBoxContainer/ItemDescription
onready var button_theme = preload("res://Themes/ListButtonTheme.tres")
onready var exit_button = $List/Button

func _input(event):
	if event.is_action_pressed("menu"):
		self.call_deferred("close_menu")

func enchild(obj):
	obj.add_child(self)
	
func display_item(item_data: Dictionary):
	if item_data['image'] != null:
		var picture = load(item_data['image'])
		item_picture.texture = picture
	else:
		item_picture.texture = null
	item_description.text = item_data['description']

func undisplay_item():
	item_picture.texture = null
	item_description.text = ''

func handle_focus_entered(label, item):
	label.grab_focus()
	display_item(item)

func handle_focus_exited(_label, _item):
	undisplay_item()

# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.grab_focus()
	var first = true
	for item in stats.inventory:
		var item_data = ItemRegistry.get(item)
		var label = Button.new()
		var count = stats.inventory[item]
		label.connect("focus_entered", self, 'handle_focus_entered', [label, item_data])
		label.connect("mouse_entered", self, 'handle_focus_entered', [label, item_data])
		label.connect("mouse_exited", self, 'handle_focus_exited', [label, item_data])
		label.theme = button_theme
		label.align = Button.ALIGN_LEFT
		items_list.add_child(label)
		if count > 1:
			label.text = item_data['name'] + ' x' + str(count)
		else:
			label.text = item_data['name']
		if first:
			display_item(item_data)
			label.grab_focus()
			first = false

func _on_Button_pressed():
	close_menu()
	
func close_menu():
	get_tree().paused = false
	queue_free()
