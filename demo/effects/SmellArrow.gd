extends Node2D

onready var stats = PlayerStats

func show_smell():
	self.visible = true

func hide_smell():
	self.visible = false

func _ready():
	stats.connect("smell_mode_started", self, "show_smell")
	stats.connect("smell_mode_ended", self, "hide_smell")
	hide_smell()

func _exit_tree():
	stats.disconnect("smell_mode_started", self, "show_smell")
	stats.disconnect("smell_mode_ended", self, "hide_smell")
