extends Area2D

var player = null
var last_player_seen = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	last_player_seen = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null
