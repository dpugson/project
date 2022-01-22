extends Node2D


onready var moves = [
	$tablet/moves/a,
	$tablet/moves/b,
	$tablet/moves/c,
	$tablet/moves/d,
	$tablet/moves/e, 
	$tablet/moves/f,
	$tablet/moves/g,
]

onready var animation = $AnimationPlayer

func clear_board():
	for move in moves:
		move.visible = false

var index = 0
func increment_game():
	if index < len(moves):
		moves[index].visible = true
	index += 1
	
# Called when the node enters the scene tree for the first time.
func _ready():
	clear_board()

func up():
	animation.play("Up")

func lower():
	animation.play("Lower")

func lowered():
	animation.play("Lowered")
