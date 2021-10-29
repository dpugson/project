extends Node2D

export(bool) var on = true

onready var lamp_flame = $lamp_flame

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	lamp_flame.visible = on


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
