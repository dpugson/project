extends KinematicBody2D

var speed = Vector2.ZERO
export var CUBE_SPEED = 100
export var friction = 6000

var Player = preload("res://player/player.gd")

func _physics_process(delta):
	var collision = move_and_collide(speed)
	if collision != null:
		if collision.collider is Player:
			speed = collision.normal * CUBE_SPEED * delta
	else:
		speed = speed.move_toward(Vector2.ZERO, friction)
