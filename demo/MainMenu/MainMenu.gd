extends Node2D

onready var cave = $ColorRect/CenterContainer/VBoxContainer/Cave

func _ready():
	_on_Cave_pressed()

func _on_Start_pressed():
	get_tree().change_scene("res://Levels/Demo/ForestDemo.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Lab_pressed():
	get_tree().change_scene("res://Levels/1.0 - Lab/Laboratory.tscn")

func _on_Cave_pressed():
	get_tree().change_scene("res://Levels/0.0 Cave/Cave01.tscn")
