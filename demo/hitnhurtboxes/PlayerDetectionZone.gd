extends Area2D

onready var collision = $CollisionShape2D

var player = null
var last_player_seen = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	last_player_seen = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null

func set_can_talk(boolean: bool):
	collision.disabled = not boolean
