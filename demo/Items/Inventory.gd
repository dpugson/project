extends CanvasLayer

onready var stats = PlayerStats
onready var items_list = $List/MarginContainer/VBoxContainer/ScrollContainer/ItemsList
onready var item_picture = $Description/MarginContainer/VBoxContainer/ItemPicture
onready var item_description = $Description/MarginContainer/VBoxContainer/ItemDescription
onready var button_theme = preload("res://Themes/ListButtonTheme.tres")
onready var exit_button = $List/Button
onready var g_label = $G_panel/Label
onready var scroll_container = $List/MarginContainer/VBoxContainer/ScrollContainer

var item_click_handler = null

func _input(event):
	if event.is_action_pressed("menu") or event.is_action_pressed("ui_cancel"):
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

func remove_item_from_list(label, prev):
	prev.grab_focus()
	label.queue_free()

func decrement_item(label, item, prev):
	var item_name = item["name"]
	var count = max(stats.inventory_get(item_name) - 1, 0)
	stats.inventory[item_name] = count
	if count == 0:
		remove_item_from_list(label, prev)
	elif count > 1:
		label.text = item_name + ' x' + str(count)
	else:
		label.text = item_name

func _on_focus_change(label):
	var focus_offset = label.rect_position.y
	var scrolled_top = scroll_container.get_v_scroll()
	var scrolled_bottom = scrolled_top + scroll_container.rect_size.y - label.rect_size.y
	if focus_offset < scrolled_top or focus_offset >= scrolled_bottom:
		scroll_container.scroll_vertical = focus_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.grab_focus()
	g_label.text = str(stats.G) + " G"
	var first = true
	var prev = exit_button
	for item in stats.inventory:
		var item_data = ItemRegistry.get(item)
		var count = stats.inventory[item]
		if count == 0:
			continue
		var label = Button.new()
		label.connect("focus_entered", self, 'handle_focus_entered', [label, item_data])
		label.connect("focus_exited", self, 'handle_focus_exited', [label, item_data])
		label.connect("mouse_entered", self, 'handle_focus_entered', [label, item_data])
		label.connect("mouse_exited", self, 'handle_focus_exited', [label, item_data])
		label.connect("pressed", self, "handle_item_pressed", [label, item_data, prev])
		label.theme = button_theme
		label.align = Button.ALIGN_LEFT
		items_list.add_child(label)
		label.connect('focus_entered', self, '_on_focus_change', [label])
		if count > 1:
			label.text = item_data['name'] + ' x' + str(count)
		else:
			label.text = item_data['name']
		if first:
			display_item(item_data)
			label.grab_focus()
			first = false
		prev = label

func _on_Button_pressed():
	close_menu()
	
func close_menu():
	get_tree().paused = false
	queue_free()

func handle_item_pressed(label, item, prev):
	if item_click_handler != null:
		item_click_handler[0].call_deferred(item_click_handler[1], self, label, item, prev)
