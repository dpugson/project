extends Control

var obstacle_map = {
	"*" : { "scene": preload("res://MiniGames/battles/StalagmiteObstacle.tscn"),
			"end_scale" : 10 }
}

func gen_random_round():
	var rows = [
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["***___", 1],
		["_***__", 1],
		["__***_", 1],
		["___***", 1],
		["**__**", 1],
	]
	

var rounds = [
	[
		["__*___", 3],
		["______", 1],
		["**____", 1],
		["_**___", 1],
		["__**__", 4],
		["**__**", 5],
	],
	[
		["*****_", 6],
		["_*****", 6],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 0.5],
		["*_____", 0.5],
		["_*____", 0.5],
		["___*__", 0.5],
		["____*_", 0.5],
		["_____*", 3],
		["**__**", 5],
	],
]

var battle_data = {
	"handler" : [self, "noop"],
	"options" : [
		"Smell", "Bark", "Play Dead", "Roll Over"
	]
}

func _ready():
	pass # Replace with function body.

func handle_act(action):
	match action:
		"Smell":
			pass
		"Bark":
			pass
		"Play Dead":
			pass
		"Roll Over":
			pass

func handle_item():
	pass

func return_next_round():
	pass
